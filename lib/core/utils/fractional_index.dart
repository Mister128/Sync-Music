const String _baseZero = 'a0';
const String _base62Alphabet =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
final _pattern = RegExp(r'^[A-Za-z][0-9A-Za-z]*$');

/// Fractional indexing for ordered lists; inserting between two
/// neighbors generates a key strictly between them lexicographically,
/// without renumbering the rest of the list.
String generateKeyBetween(String? a, String? b) {
  if (a == null && b == null) return _baseZero;
  _validate(a);
  _validate(b);
  if (a != null && b != null) {
    if (a.compareTo(b) >= 0) {
      throw ArgumentError('keys out of order: a ($a) must be < b ($b)');
    }
  }
  if (a == null) {
    final parsed = _parse(b!);
    if (parsed.fraction.isNotEmpty) {
      return parsed.head + parsed.integer;
    }
    return _decrementInteger(b);
  }
  if (b == null) {
    return _incrementInteger(a);
  }

  final parsedA = _parse(a);
  final parsedB = _parse(b);
  final intA = parsedA.head + parsedA.integer;
  final intB = parsedB.head + parsedB.integer;

  if (intA == intB) {
    return intA + _midpoint(parsedA.fraction, parsedB.fraction);
  }
  final next = _incrementInteger(intA);
  if (next.compareTo(b) < 0) {
    return next;
  }

  return intA + _midpoint(parsedA.fraction, null);
}

String _incrementInteger(String key) {
  final (:head, :integer, fraction: _) = _parse(key);
  var zeroSuffix = 0;

  for (var i = integer.length - 1; i >= 0; i--) {
    if (integer[i] == 'z') {
      zeroSuffix++;
    } else {
      return head +
          integer.substring(0, i) +
          _base62Alphabet[_base62Alphabet.indexOf(integer[i]) + 1] +
          '0' * zeroSuffix;
    }
  }
  if (head == 'z') {
    throw StateError('largest integer key');
  }
  final newHead = _base62Alphabet[_base62Alphabet.indexOf(head) + 1];
  return newHead + '0' * _integerLength(newHead);
}

String _decrementInteger(String key) {
  final (:head, :integer, fraction: _) = _parse(key);
  var zSuffix = 0;

  for (var i = integer.length - 1; i >= 0; i--) {
    if (integer[i] == '0') {
      zSuffix++;
    } else {
      return head +
          integer.substring(0, i) +
          _base62Alphabet[_base62Alphabet.indexOf(integer[i]) - 1] +
          'z' * zSuffix;
    }
  }
  if (head == 'A') {
    throw StateError('smallest integer key');
  }
  final newHead = _base62Alphabet[_base62Alphabet.indexOf(head) - 1];
  return newHead + 'z' * _integerLength(newHead);
}

/// Midpoint of two FRACTION digit-strings (NOT keys - no head, no
/// validation here). Preconditions, guaranteed by the caller:
/// b == null || a < b; neither fraction ends with '0'.
String _midpoint(String a, String? b) {
  if (b != null) {
    var n = 0;
    while (n < b.length && (n < a.length ? a[n] : '0') == b[n]) {
      n++;
    }
    if (n > 0) {
      final tailA = n < a.length ? a.substring(n) : '';
      return b.substring(0, n) + _midpoint(tailA, b.substring(n));
    }
  }

  final digitA = a.isEmpty ? 0 : _base62Alphabet.indexOf(a[0]);
  final digitB = b == null
      ? _base62Alphabet.length
      : _base62Alphabet.indexOf(b[0]);

  if (digitB - digitA > 1) {
    return _base62Alphabet[((digitA + digitB) / 2).round()];
  }

  if (b != null && b.length > 1) {
    return b[0];
  }
  final tail = a.length > 1 ? a.substring(1) : '';
  return _base62Alphabet[digitA] + _midpoint(tail, null);
}

void _validate(String? key) {
  if (key == null) return;
  if (key.isEmpty) throw ArgumentError('empty key');

  if (key.length >= 1 + _integerLength(key[0]) && _pattern.hasMatch(key)) {
    final fraction = _parse(key).fraction;
    if (fraction.endsWith('0')) {
      throw ArgumentError('fraction must not end with a zero: $key');
    }
  } else {
    throw ArgumentError('illegal key: $key');
  }
}

({String head, String integer, String fraction}) _parse(String key) {
  final head = key[0];
  final len = _integerLength(head);

  return (
    head: head,
    integer: key.substring(1, len + 1),
    fraction: key.substring(len + 1),
  );
}

/// Integer-part length implied by the head char:
/// 'a'..'z' -> 1..26 (non-negative side), 'Z'..'A' -> 1..26 (negative side).
int _integerLength(String head) {
  final firstChar = head.codeUnitAt(0);

  int len;
  if (firstChar >= 'a'.codeUnitAt(0)) {
    len = firstChar - 'a'.codeUnitAt(0) + 1;
  } else {
    len = 'Z'.codeUnitAt(0) - firstChar + 1;
  }
  return len;
}
