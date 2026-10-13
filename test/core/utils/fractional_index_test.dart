import 'package:flutter_test/flutter_test.dart';

import 'package:sync_music/core/utils/fractional_index.dart';

void main() {
  group('contract anchors (rocicorp-compatible format)', () {
    test('the very first key is the zero point', () {
      expect(generateKeyBetween(null, null), 'a0');
    });

    test('append increments the integer part', () {
      expect(generateKeyBetween('a0', null), 'a1');
      expect(generateKeyBetween('a1', null), 'a2');
    });

    test('prepend before zero crosses to the negative side', () {
      expect(generateKeyBetween(null, 'a0'), 'Zz');
      expect(generateKeyBetween(null, 'Zz'), 'Zy');
    });

    test('between integers with room -> the integer between', () {
      expect(generateKeyBetween('a0', 'a2'), 'a1');
    });

    test('between adjacent integers -> fractional midpoint digit', () {
      // 'V' is the middle of the 62-digit alphabet (index 31).
      expect(generateKeyBetween('a0', 'a1'), 'a0V');
    });

    test('carry grows the head, keeping lexicographic order', () {
      // A naive "append a char" would give 'az1' - but 'az1' > 'b..' is
      // false, order would break. The head encodes the length: 'b00'.
      expect(generateKeyBetween('az', null), 'b00');
    });

    test('append after a fractional key returns the next INTEGER', () {
      // The fraction is dropped: 'a1' > 'a0V', and keys stop growing.
      expect(generateKeyBetween('a0V', null), 'a1');
    });

    test('prepend before a fractional key can land on its integer part', () {
      // 'a0' < 'a0V' - the integer part itself is the canonical answer.
      expect(generateKeyBetween(null, 'a0V'), 'a0');
    });

    test('a fraction starting with zero survives the prefix walk', () {
      // midpoint('', '0V'): the padded '0' matches b's '0', so the prefix
      // index outruns a.length - the Dart substring guard must hold.
      expect(generateKeyBetween('a0', 'a00V'), 'a00G');
    });
  });

  group('invariants', () {
    test('100 appends stay strictly increasing', () {
      String? prev;
      for (var i = 0; i < 100; i++) {
        final next = generateKeyBetween(prev, null);
        if (prev != null) {
          expect(
            next.compareTo(prev),
            greaterThan(0),
            reason: 'append broke order: $prev -> $next',
          );
        }
        prev = next;
      }
    });

    test('100 prepends stay strictly decreasing', () {
      String? next;
      for (var i = 0; i < 100; i++) {
        final prev = generateKeyBetween(null, next);
        if (next != null) {
          expect(
            prev.compareTo(next),
            lessThan(0),
            reason: 'prepend broke order: $prev -> $next',
          );
        }
        next = prev;
      }
    });

    test('500 middle inserts keep the whole list sorted and unique', () {
      final keys = ['a0', 'a1'];
      for (var i = 0; i < 500; i++) {
        // Deterministic "random-ish" spot, edges included (null neighbors).
        final at = i % (keys.length + 1);
        final left = at == 0 ? null : keys[at - 1];
        final right = at == keys.length ? null : keys[at];
        keys.insert(at, generateKeyBetween(left, right));
      }
      for (var j = 1; j < keys.length; j++) {
        expect(
          keys[j - 1].compareTo(keys[j]),
          lessThan(0),
          reason: 'order broken at $j: ${keys[j - 1]} >= ${keys[j]}',
        );
      }
    });

    test('generated keys stay in the documented charset', () {
      final pattern = RegExp(r'^[A-Za-z][0-9A-Za-z]*$');
      var key = 'a0';
      for (var i = 0; i < 50; i++) {
        final before = generateKeyBetween(null, key);
        expect(before, matches(pattern), reason: 'illegal key: $before');
        key = generateKeyBetween(key, null);
        expect(key, matches(pattern), reason: 'illegal key: $key');
      }
    });
  });

  group('invalid input', () {
    test('a >= b is a caller bug', () {
      expect(() => generateKeyBetween('a1', 'a1'), throwsArgumentError);
      expect(() => generateKeyBetween('a2', 'a1'), throwsArgumentError);
    });

    test('empty keys are rejected', () {
      expect(() => generateKeyBetween('', 'a0'), throwsArgumentError);
      expect(() => generateKeyBetween('a0', ''), throwsArgumentError);
      expect(() => generateKeyBetween('', null), throwsArgumentError);
      expect(() => generateKeyBetween(null, ''), throwsArgumentError);
    });

    test('keys with illegal characters are rejected', () {
      expect(() => generateKeyBetween('a!', null), throwsArgumentError);
      expect(() => generateKeyBetween(null, 'a-1'), throwsArgumentError);
    });
  });
}
