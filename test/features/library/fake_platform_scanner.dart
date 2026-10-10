import 'package:sync_music/features/library/data/datasources/platform_media_scanner.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';

/// In-test stand-in for MediaStore: settable entries and permission flag.
/// Real files back the entries, so the parse stage runs for real.
/// In DESKTOP tests it doubles as a "must never be called" dummy.
class FakePlatformScanner implements PlatformMediaScanner {
  new({this.granted = true, this.entries = const []});

  bool granted;
  List<FileEntry> entries;
  int permissionRequests = 0;
  int queryCalls = 0;

  @override
  Future<bool> hasPermission() async => granted;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return granted;
  }

  @override
  Future<List<FileEntry>> queryAudioFiles() async {
    queryCalls++;
    return entries;
  }
}
