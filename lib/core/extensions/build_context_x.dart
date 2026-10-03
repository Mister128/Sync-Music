// NOTE: widgets.dart, not material.dart — the extension needs only
// BuildContext + MediaQuery, keep imports minimal.
import 'package:flutter/widgets.dart';

import 'package:sync_music/core/design_system/theme/app_breakpoints.dart';

extension ResponsiveBuildContext on BuildContext {
  /// True when the window is narrower than the "medium" size class
  /// (phone layout: bottom NavigationBar, no rail).
  bool get isCompact => MediaQuery.sizeOf(this).width < AppBreakpoints.medium;

  // TODO(Mister128): grow this into a `windowSizeClass` getter returning
  // an enum (compact/medium/expanded) when the desktop 2-3 panel layouts
  // arrive. One extension = one place for all responsive questions.
}
