import 'package:intl/intl.dart';

/// Useful extension methods on core Dart types.

extension DateTimeExtension on DateTime {
  /// Formats as "Jun 17, 2024"
  String get formattedDate => DateFormat('MMM d, y').format(this);

  /// Formats as "2:30 PM"
  String get formattedTime => DateFormat('h:mm a').format(this);

  /// Formats as "Jun 17, 2024 at 2:30 PM"
  String get formattedFull => '${DateFormat('MMM d, y').format(this)} at ${DateFormat('h:mm a').format(this)}';

  /// Returns a relative time string like "2 hours ago"
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formattedDate;
  }
}

extension DurationExtension on Duration {
  /// Formats duration as "4.2s" or "1m 12s"
  String get formatted {
    if (inMinutes > 0) {
      final secs = inSeconds % 60;
      return '${inMinutes}m ${secs}s';
    }
    final ms = inMilliseconds % 1000;
    return '$inSeconds.${ms ~/ 100}s';
  }
}

extension DoubleExtension on double {
  /// Formats as percentage: 0.92 â†’ "92%"
  String get asPercentage => '${(this * 100).toStringAsFixed(0)}%';

  /// Formats as percentage with one decimal: 0.923 â†’ "92.3%"
  String get asPercentageDetailed => '${(this * 100).toStringAsFixed(1)}%';
}

extension StringExtension on String {
  /// Capitalizes the first letter.
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Truncates to [maxLength] with ellipsis.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}â€¦';
  }
}