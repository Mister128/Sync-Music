/// User input -> a SAFE FTS5 MATCH expression.
library;

final _hasWordChar = RegExp(r'[\p{L}\p{N}_]', unicode: true);

/// FTS5 has its OWN query syntax (quotes, *, OR, NOT, NEAR, parentheses,
/// column filters...), so raw input must never reach MATCH. Rules:
/// - tokens without a single word character are dropped (punctuation-only
///   input would otherwise produce degenerate queries);
/// - every token is double-quoted, inner quotes doubled - nothing can
///   escape the quoting, FTS5 operators become plain text;
/// - tokens are joined with the implicit AND;
/// - the LAST token gets a `*` suffix - prefix matching, so "mum" already
///   finds "Mumiy Troll" (every sensible media app searches as-you-type).
///
/// Returns '' for blank/unsalvageable input - callers skip the search.
String buildMatchQuery(String raw) {
  final tokens = [
    for (final token in raw.trim().split(RegExp(r'\s+')))
      if (token.isNotEmpty && _hasWordChar.hasMatch(token)) token,
  ];
  if (tokens.isEmpty) return '';

  final quoted = [
    for (final token in tokens) '"${token.replaceAll('"', '""')}"',
  ];
  quoted[quoted.length - 1] = '${quoted.last}*';
  return quoted.join(' ');
}
