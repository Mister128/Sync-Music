import 'package:flutter_test/flutter_test.dart';
import 'package:sync_music/core/utils/ids.dart';

void main() {
  test('generate unique ids', () {
    final ids = List.generate(1000, (_) => newId());
    expect(ids.toSet(), hasLength(1000));
  });

  test('ids sort by creation time', () async {
    final first = newId();

    await Future<void>.delayed(const Duration(milliseconds: 2));
    final second = newId();
    expect(first.compareTo(second), lessThan(0));
  });

  test('id is a valid UUID v7 string', () {
    // xxxxxxxx-xxxx-7xxx-yxxx-xxxxxxxxxxxx where 7 = version,
    // y in [8,9,a,b] = RFC 4122 variant bits.
    expect(
      newId(),
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
  });
}
