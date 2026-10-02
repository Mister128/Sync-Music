/// Material 3 window size classes, in logical pixels (dp).
///
/// compact:  0   <= w <  600   (phones)
/// medium:   600 <= w <  840   (small tablets, narrow desktop windows)
/// expanded: 840 <= w          (tablets, desktop)
///
/// Single source of truth — never hardcode 600 in widgets.
abstract final class AppBreakpoints {
  static const double medium = 600;
  static const double expanded = 840;
}