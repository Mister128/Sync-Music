package com.mistery.sync_music

import android.content.ContentUris
import android.content.Intent
import android.content.IntentSender
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import androidx.annotation.RequiresApi
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// The single MethodChannel bridge: Dart asks for "every audio file the
/// system knows" and gets (path, sizeBytes, mtimeMs) triples - the same
/// shape the desktop filesystem walker produces. It also
/// runs permanent deletes through MediaStore.createDeleteRequest.
class MainActivity : AudioServiceActivity() {
    private val channelName = "sync_music/media_store"

    private companion object {
        const val DELETE_REQUEST_CODE = 4242
    }

    // Held across the system delete dialog: the Dart call completes when
    // onActivityResult arrives.
    private var pendingDeleteResult: MethodChannel.Result? = null
    private var pendingDeletePaths: List<String> = emptyList()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "queryAudioFiles" -> {
                        // Cursor iteration is fast but not free - keep the
                        // platform thread clean, answer from a worker thread.
                        // result.success() must be called back on the UI thread.
                        Thread {
                            val files = queryAudioFiles()
                            runOnUiThread { result.success(files) }
                        }.start()
                    }
                    "deleteFiles" -> {
                        @Suppress("UNCHECKED_CAST")
                        val paths = call.arguments as? List<String> ?: emptyList()
                        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
                            // Below API 30 there is no createDeleteRequest and
                            // no WRITE permission by design - honest "unsupported".
                            result.success(emptyList<String>())
                        } else {
                            Thread {
                                val uris = mutableListOf<Uri>()
                                val found = mutableListOf<String>()
                                for (path in paths) {
                                    val id = queryMediaId(path) ?: continue
                                    uris.add(
                                        ContentUris.withAppendedId(
                                            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                                            id,
                                        ),
                                    )
                                    found.add(path)
                                }
                                runOnUiThread {
                                    if (uris.isEmpty()) {
                                        result.success(emptyList<String>())
                                    } else {
                                        startDeleteRequest(uris, found, result)
                                    }
                                }
                            }.start()
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    @RequiresApi(Build.VERSION_CODES.R)
    private fun startDeleteRequest(
        uris: List<Uri>,
        paths: List<String>,
        result: MethodChannel.Result,
    ) {
        pendingDeleteResult = result
        pendingDeletePaths = paths
        val request = MediaStore.createDeleteRequest(contentResolver, uris)
        try {
            startIntentSenderForResult(
                request.intentSender, DELETE_REQUEST_CODE, null, 0, 0, 0,
            )
        } catch (e: IntentSender.SendIntentException) {
            pendingDeleteResult = null
            pendingDeletePaths = emptyList()
            result.success(emptyList<String>())
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != DELETE_REQUEST_CODE) return
        val result = pendingDeleteResult ?: return
        pendingDeleteResult = null
        // The system dialog is all-or-nothing: RESULT_OK = every listed
        // file was removed (MediaStore rows included).
        val deleted = if (resultCode == RESULT_OK) pendingDeletePaths else emptyList()
        pendingDeletePaths = emptyList()
        result.success(deleted)
    }

    // DATA is deprecated but it is the only column giving a real file path,
    // and with READ_MEDIA_AUDIO granted opening audio files by path is
    // allowed even under scoped storage.
    @Suppress("DEPRECATION")
    private fun queryAudioFiles(): List<Map<String, Any>> {
        val files = mutableListOf<Map<String, Any>>()
        val projection = arrayOf(
            MediaStore.Audio.Media.DATA,
            MediaStore.Audio.Media.SIZE,
            MediaStore.Audio.Media.DATE_MODIFIED,
        )
        // IS_MUSIC skips ringtones / notification sounds / alarms.
        val selection = "${MediaStore.Audio.Media.IS_MUSIC} != 0"

        contentResolver.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            projection,
            selection,
            null,
            null,
        )?.use { cursor ->
            val pathIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)
            val sizeIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.SIZE)
            val mtimeIdx = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATE_MODIFIED)

            while (cursor.moveToNext()) {
                val path = cursor.getString(pathIdx) ?: continue
                files.add(
                    mapOf(
                        "path" to path,
                        "sizeBytes" to cursor.getLong(sizeIdx),
                        // MediaStore stores SECONDS - the Dart side works in ms.
                        "mtimeMs" to cursor.getLong(mtimeIdx) * 1000L,
                    ),
                )
            }
        }
        return files
    }

    @Suppress("DEPRECATION")
    private fun queryMediaId(path: String): Long? {
        contentResolver.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            arrayOf(MediaStore.Audio.Media._ID),
            "${MediaStore.Audio.Media.DATA} = ?",
            arrayOf(path),
            null,
        )?.use { cursor ->
            if (cursor.moveToFirst()) return cursor.getLong(0)
        }
        return null
    }
}