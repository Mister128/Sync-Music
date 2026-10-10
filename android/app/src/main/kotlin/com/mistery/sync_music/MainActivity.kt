package com.mistery.sync_music

import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// The single MethodChannel bridge: Dart asks for "every audio file the
/// system knows" and gets (path, sizeBytes, mtimeMs) triples - the same
/// shape the desktop filesystem walker produces.
class MainActivity : FlutterActivity() {
    private val channelName = "sync_music/media_store"

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
                    else -> result.notImplemented()
                }
            }
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
}