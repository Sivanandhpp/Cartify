/// Utility class for formatting various data types
///
/// This class provides consistent formatting across the application
/// for currencies, dates, numbers, and other data types.
class AppFormatters {
  AppFormatters._();

  /// Format currency with full precision
  static String currency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  /// Format currency in compact form (e.g., $1.2K, $1M)
  static String compactCurrency(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return currency(amount);
    }
  }

  /// Format number with thousands separators
  static String number(int number) {
    return _addThousandsSeparator(number.toString());
  }

  /// Format decimal number with thousands separators
  static String decimal(double number) {
    final parts = number.toStringAsFixed(2).split('.');
    return '${_addThousandsSeparator(parts[0])}.${parts[1]}';
  }

  /// Format percentage (0.25 → 25%)
  static String percentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }

  /// Format number in compact form (e.g., 1.2K, 1M)
  static String compact(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  /// Helper method to add thousands separators
  static String _addThousandsSeparator(String number) {
    final reversed = number.split('').reversed.join('');
    final withCommas = <String>[];

    for (int i = 0; i < reversed.length; i += 3) {
      final end = (i + 3 < reversed.length) ? i + 3 : reversed.length;
      withCommas.add(reversed.substring(i, end));
    }

    return withCommas.join(',').split('').reversed.join('');
  }

  /// Format date (e.g., Jan 15, 2024)
  static String date(DateTime date) {
    final months = [
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

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Format time (e.g., 02:30 PM)
  static String time(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Format date and time (e.g., Jan 15, 2024 02:30 PM)
  static String dateTime(DateTime dateTime) {
    return '${date(dateTime)} ${time(dateTime)}';
  }

  /// Format date in short form (e.g., 01/15/2024)
  static String shortDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Format date in ISO format
  static String isoDate(DateTime date) {
    return date.toIso8601String();
  }

  /// Format relative time (e.g., "2 hours ago", "yesterday")
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1
          ? 'yesterday'
          : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1
          ? '1 hour ago'
          : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1
          ? '1 minute ago'
          : '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }

  /// Format duration (e.g., "2h 30m", "1d 5h")
  static String duration(Duration duration) {
    if (duration.inDays > 0) {
      final days = duration.inDays;
      final hours = duration.inHours % 24;
      if (hours > 0) {
        return '${days}d ${hours}h';
      } else {
        return '${days}d';
      }
    } else if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      } else {
        return '${hours}h';
      }
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Format file size (e.g., "1.5 MB", "2.3 GB")
  static String fileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Format phone number (e.g., "+1 (555) 123-4567")
  static String phoneNumber(String phone) {
    // Remove all non-digit characters
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length == 10) {
      // US format: (555) 123-4567
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      // US format with country code: +1 (555) 123-4567
      return '+1 (${digitsOnly.substring(1, 4)}) ${digitsOnly.substring(4, 7)}-${digitsOnly.substring(7)}';
    } else {
      // Return original if format not recognized
      return phone;
    }
  }

  /// Format rating with stars (e.g., "4.5 ★★★★☆")
  static String rating(double rating, {int maxStars = 5}) {
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;
    final emptyStars = maxStars - fullStars - (hasHalfStar ? 1 : 0);

    final stars = StringBuffer();

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.write('★');
    }

    // Add half star if needed
    if (hasHalfStar) {
      stars.write('⭐');
    }

    // Add empty stars
    for (int i = 0; i < emptyStars; i++) {
      stars.write('☆');
    }

    return '${rating.toStringAsFixed(1)} ${stars.toString()}';
  }

  /// Capitalize first letter of each word
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  /// Format credit card number (e.g., "**** **** **** 1234")
  static String creditCard(String cardNumber, {bool maskAll = false}) {
    final digitsOnly = cardNumber.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length < 4) return cardNumber;

    if (maskAll) {
      return '**** **** **** ****';
    } else {
      final lastFour = digitsOnly.substring(digitsOnly.length - 4);
      return '**** **** **** $lastFour';
    }
  }
}




