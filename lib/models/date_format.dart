import 'package:intl/intl.dart';

// 20 Date Format Options

/// A model class that provides various date formatting options using the intl library.
class DateFormatModel {
  final DateTime dateTime;

  DateFormatModel(this.dateTime);

  /// Creates a DateFormatModel from the current date/time
  factory DateFormatModel.now() {
    return DateFormatModel(DateTime.now());
  }

  /// Creates a DateFormatModel from a string
  factory DateFormatModel.parse(String dateString) {
    return DateFormatModel(DateTime.parse(dateString));
  }

  // Common Date Formats

  /// Returns date in format: Aug 24, 1995
  String get mediumDate => DateFormat.yMMMd().format(dateTime);

  /// Returns date in format: August 24, 1995
  String get longDate => DateFormat.yMMMMd().format(dateTime);

  /// Returns date in format: 8/24/1995
  String get shortDate => DateFormat.yMd().format(dateTime);

  /// Returns date in format: 1995-08-24
  String get isoDate => DateFormat('yyyy-MM-dd').format(dateTime);

  /// Returns date in format: Thursday, August 24, 1995
  String get fullDate => DateFormat.yMMMMEEEEd().format(dateTime);

  /// Returns date in format: Thu, Aug 24, 1995
  String get abbrevDate => DateFormat.yMMMEd().format(dateTime);

  // Month and Year Formats

  /// Returns date in format: August 1995
  String get monthYear => DateFormat.yMMMM().format(dateTime);

  /// Returns date in format: Aug 1995
  String get abbrevMonthYear => DateFormat.yMMM().format(dateTime);

  /// Returns date in format: 08/1995
  String get numericMonthYear => DateFormat('MM/yyyy').format(dateTime);

  // Day and Month Formats

  /// Returns date in format: August 24
  String get monthDay => DateFormat.MMMMd().format(dateTime);

  /// Returns date in format: Aug 24
  String get abbrevMonthDay => DateFormat.MMMd().format(dateTime);

  /// Returns date in format: 08/24
  String get numericMonthDay => DateFormat.Md().format(dateTime);

  // Weekday Formats

  /// Returns weekday in format: Thursday
  String get weekday => DateFormat.EEEE().format(dateTime);

  /// Returns weekday in format: Thu
  String get abbrevWeekday => DateFormat.E().format(dateTime);

  /// Returns date in format: Thursday, Aug 24
  String get weekdayMonthDay => DateFormat.MMMMEEEEd().format(dateTime);

  // Year Formats

  /// Returns year in format: 1995
  String get year => DateFormat.y().format(dateTime);

  /// Returns year in format: 95
  String get shortYear => DateFormat('yy').format(dateTime);

  // Custom Formats

  /// Returns date in format: 24-Aug-1995
  String get dashedDate => DateFormat('dd-MMM-yyyy').format(dateTime);

  /// Returns date in format: 24.08.1995
  String get dottedDate => DateFormat('dd.MM.yyyy').format(dateTime);

  /// Returns date in format: Aug 24th, 1995
  String get dateWithOrdinal {
    final day = dateTime.day;
    final suffix = _getOrdinalSuffix(day);
    return DateFormat('MMM d\'$suffix\', yyyy').format(dateTime);
  }

  // Utility Methods

  /// Helper method to get ordinal suffix for day
  String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Format with a custom pattern
  String format(String pattern) {
    return DateFormat(pattern).format(dateTime);
  }

  @override
  String toString() => isoDate;
}
