import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'package:deepshield_ai/features/analysis/data/models/scan_result_model.dart';

/// General helper utilities.
class Helpers {
  Helpers._();

  /// Returns the color associated with a risk level.
  static Color riskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppColors.riskLow;
      case RiskLevel.medium:
        return AppColors.riskMedium;
      case RiskLevel.high:
        return AppColors.riskHigh;
    }
  }

  /// Returns the icon for a risk level.
  static IconData riskIcon(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return Icons.check_circle_rounded;
      case RiskLevel.medium:
        return Icons.warning_rounded;
      case RiskLevel.high:
        return Icons.error_rounded;
    }
  }

  /// Returns the icon for a media type.
  static IconData mediaTypeIcon(MediaType type) {
    switch (type) {
      case MediaType.image:
        return Icons.image_rounded;
      case MediaType.video:
        return Icons.videocam_rounded;
    }
  }

  /// Shows a snackbar with the given message.
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}