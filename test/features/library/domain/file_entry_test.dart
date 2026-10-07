import 'package:flutter_test/flutter_test.dart';
import 'package:sync_music/features/library/domain/entities/file_entry.dart';

void main() {
  test('equality is structural', () {
    const a = FileEntry(path: 'x.mp3', sizeBytes: 1, mtimeMs: 2);
    const b = FileEntry(path: 'x.mp3', sizeBytes: 1, mtimeMs: 2);

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a.copyWith(mtimeMs: 3), isNot(b));
  });
}
