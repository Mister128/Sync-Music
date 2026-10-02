import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sync_music/core/design_system/theme/app_colors.dart';
import 'package:sync_music/core/design_system/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);

  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.neutral,
    );

    final scheme = brightness == Brightness.dark
        ? base.copyWith(
            surface: const Color(0xFF171719),
            surfaceContainerLowest: const Color(0xFF0F0F11),
            surfaceContainerLow: const Color(0xFF131315),
            surfaceContainer: const Color(0xFF171719),
            surfaceContainerHigh: const Color(0xFF1D1D20),
            surfaceContainerHighest: const Color(0xFF242427),

            primary: Colors.deepPurple,
            onPrimary: Colors.white,

            secondaryContainer: Colors.deepPurple.shade700,
            onSecondaryContainer: Colors.white,
          )
        : base.copyWith(
            primary: Colors.deepPurple,
            onPrimary: Colors.white,
            secondaryContainer: Colors.deepPurple.shade500,
            onSecondaryContainer: Colors.white,
          );

    return ThemeData(
      colorScheme: scheme,
      textTheme: AppTypography.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.textTheme.headlineSmall?.copyWith(
          color: scheme.onSurface,
        ),
      ),
    );
  }
}
