import 'package:flutter_test/flutter_test.dart';
import 'package:sync_music/core/constants/audio_extensions.dart';

void main() {
  test('is audio file', () {
    const testPath = 'track.opus';
    expect(isAudioFile(testPath), isTrue);
  });

  test('not audio file', () {
    const testPath = 'notTrack.html';
    expect(isAudioFile(testPath), isFalse);
  });

  test('audio file with upper case', () {
    const testPath = 'TRACK.MP3';
    expect(isAudioFile(testPath), isTrue);
  });

  test('full path with directories and mixed case', () {
    expect(isAudioFile(r'C:\Music\Queen\A Night at the Opera\01 - Death on Two Legs.FLAC'), isTrue);
  });

  test('no extension / video are not audio', () {
    expect(isAudioFile('README'), isFalse);
    expect(isAudioFile('movie.mp4'), isFalse);
    expect(isAudioFile('clip.mkv'), isFalse);
  });
}
