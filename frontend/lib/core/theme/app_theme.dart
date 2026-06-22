import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// TrueLens AI theme configuration.
///
/// Provides both light and dark [ThemeData] using Material 3 with
/// a custom color scheme, typography, and component themes.
class AppTheme {
  AppTheme._();

  // ————————————————————————————————————————
  // Light Theme
  // ————————————————————————————————————————

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight.withValues(alpha: 0.12),
      onPrimaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryLight.withValues(alpha: 0.12),
      onSecondaryContainer: AppColors.secondaryLight,
      tertiary: AppColors.tertiaryLight,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.tertiaryLight.withValues(alpha: 0.12),
      onTertiaryContainer: AppColors.tertiaryLight,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      onSurfaceVariant: AppColors.textSecondaryLight,
      outline: AppColors.dividerLight,
      outlineVariant: AppColors.dividerLight.withValues(alpha: 0.5),
      shadow: Colors.black.withValues(alpha: 0.08),
      scrim: Colors.black.withValues(alpha: 0.3),
      inverseSurface: AppColors.surfaceDark,
      onInverseSurface: AppColors.textPrimaryDark,
      inversePrimary: AppColors.primaryDark,
      surfaceContainerHighest: const Color(0xFFF1F5F9),
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  // ————————————————————————————————————————
  // Dark Theme
  // ————————————————————————————————————————

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: Colors.black,
      primaryContainer: AppColors.primaryDark.withValues(alpha: 0.15),
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      onSecondary: Colors.black,
      secondaryContainer: AppColors.secondaryDark.withValues(alpha: 0.15),
      onSecondaryContainer: AppColors.secondaryDark,
      tertiary: AppColors.tertiaryDark,
      onTertiary: Colors.black,
      tertiaryContainer: AppColors.tertiaryDark.withValues(alpha: 0.15),
      onTertiaryContainer: AppColors.tertiaryDark,
      error: AppColors.errorDark,
      onError: Colors.black,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: AppColors.dividerDark,
      outlineVariant: AppColors.dividerDark.withValues(alpha: 0.5),
      shadow: Colors.black.withValues(alpha: 0.3),
      scrim: Colors.black.withValues(alpha: 0.6),
      inverseSurface: AppColors.surfaceLight,
      onInverseSurface: AppColors.textPrimaryLight,
      inversePrimary: AppColors.primaryLight,
      surfaceContainerHighest: const Color(0xFF1E293B),
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  // ————————————————————————————————————————
  // Shared Theme Builder
  // ————————————————————————————————————————

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textTheme = AppTypography.buildTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      fontFamily: GoogleFonts.inter().fontFamily,

      // ——— AppBar ———
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppSpacing.iconDefault,
        ),
      ),

      // ——— Card ———
      cardTheme: CardThemeData(
        elevation: isDark ? 0 : AppSpacing.elevationSmall,
        shadowColor: colorScheme.shadow,
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          side: isDark
              ? BorderSide(color: AppColors.dividerDark.withValues(alpha: 0.3))
              : BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),

      // ——— Elevated Button ———
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ——— Outlined Button ———
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          side: BorderSide(color: colorScheme.outline),
          foregroundColor: colorScheme.onSurface,
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ——— Text Button ———
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ——— Input Decoration ———
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.cardDark
            : colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing16,
          vertical: AppSpacing.spacing16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1.5,
          ),
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // ——— Bottom Navigation ———
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.labelSmall,
      ),

      // ——— Divider ———
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),

      // ——— Chip ———
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        side: BorderSide.none,
      ),

      // ——— Bottom Sheet ———
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXXLarge),
          ),
        ),
      ),

      // ——— Dialog ———
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXLarge),
        ),
      ),

      // ——— Snackbar ———
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
      ),

      // ——— Page Transitions ———
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

}