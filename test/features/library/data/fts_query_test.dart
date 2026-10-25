import 'package:flutter_test/flutter_test.dart';
import 'package:sync_music/features/library/data/datasources/fts_query.dart';

void main() {
  group('buildMatchQuery', () {
    test('blank or unsalvageable input -> empty (callers skip)', () {
      expect(buildMatchQuery(''), '');
      expect(buildMatchQuery('   '), '');
      expect(buildMatchQuery('"'), '');
      expect(buildMatchQuery('!!!'), '');
    });

    test('single token: quoted, prefix star', () {
      expect(buildMatchQuery('mum'), '"mum"*');
    });

    test('tokens are implicit AND, only the LAST one is a prefix', () {
      expect(buildMatchQuery('mumiy troll'), '"mumiy" "troll"*');
    });

    test('inner quotes are doubled - nothing escapes the quoting', () {
      expect(buildMatchQuery('say "hi"'), '"say" """hi"""*');
    });

    test('FTS5 operators become plain text', () {
      expect(buildMatchQuery('a OR b NEAR(c)'), '"a" "OR" "b" "NEAR(c)"*');
    });
  });
}
