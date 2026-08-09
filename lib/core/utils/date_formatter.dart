/// Utility for formatting dates consistently across the app.
abstract final class DateFormatter {
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> _fullMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Formats a DateTime as a short date string.
  ///
  /// Example: 18 Jul 2026
  static String formatShort(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  /// Formats a DateTime as a full date string.
  ///
  /// Example: 18 July 2026
  static String formatFull(DateTime date) {
    return '${date.day} ${_fullMonths[date.month - 1]} ${date.year}';
  }

  /// Formats a DateTime as a date and time string.
  ///
  /// Example: 18 Jul 2026, 10:30 AM
  static String formatDateTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${formatShort(date)}, $hour:$minute $period';
  }

  /// Returns a relative time string.
  ///
  /// Example: Just now, 5 min ago, 2 hours ago, Yesterday, 18 Jul 2026
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatShort(date);
    }
  }
}
