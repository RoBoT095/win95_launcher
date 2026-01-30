import 'package:intl/intl.dart';

// 20 Date Format Options

/// Enum representing available date format types
enum DateFormatType {
  /// Aug 24, 1995
  mediumDate,

  /// August 24, 1995
  longDate,

  /// 8/24/1995
  shortDate,

  /// 1995-08-24
  isoDate,

  /// Thursday, August 24, 1995
  fullDate,

  /// Thu, Aug 24, 1995
  abbrevDate,

  /// August 1995
  monthYear,

  /// Aug 1995
  abbrevMonthYear,

  /// 08/1995
  numericMonthYear,

  /// August 24
  monthDay,

  /// Aug 24
  abbrevMonthDay,

  /// 08/24
  numericMonthDay,

  /// Thursday
  weekday,

  /// Thu
  abbrevWeekday,

  /// Thursday, Aug 24
  weekdayMonthDay,

  /// 1995
  year,

  /// 95
  shortYear,

  /// 24-Aug-1995
  dashedDate,

  /// 24.08.1995
  dottedDate,

  /// Aug 24th, 1995
  dateWithOrdinal,
}

/// Extension to provide example strings for DateFormatType
extension DateFormatTypeExtension on DateFormatType {
  String get example {
    switch (this) {
      case DateFormatType.mediumDate:
        return 'Aug 24, 1995';
      case DateFormatType.longDate:
        return 'August 24, 1995';
      case DateFormatType.shortDate:
        return '8/24/1995';
      case DateFormatType.isoDate:
        return '1995-08-24';
      case DateFormatType.fullDate:
        return 'Thursday, August 24, 1995';
      case DateFormatType.abbrevDate:
        return 'Thu, Aug 24, 1995';
      case DateFormatType.monthYear:
        return 'August 1995';
      case DateFormatType.abbrevMonthYear:
        return 'Aug 1995';
      case DateFormatType.numericMonthYear:
        return '08/1995';
      case DateFormatType.monthDay:
        return 'August 24';
      case DateFormatType.abbrevMonthDay:
        return 'Aug 24';
      case DateFormatType.numericMonthDay:
        return '08/24';
      case DateFormatType.weekday:
        return 'Thursday';
      case DateFormatType.abbrevWeekday:
        return 'Thu';
      case DateFormatType.weekdayMonthDay:
        return 'Thursday, Aug 24';
      case DateFormatType.year:
        return '1995';
      case DateFormatType.shortYear:
        return '95';
      case DateFormatType.dashedDate:
        return '24-Aug-1995';
      case DateFormatType.dottedDate:
        return '24.08.1995';
      case DateFormatType.dateWithOrdinal:
        return 'Aug 24th, 1995';
    }
  }
}

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

  /// Format using a DateFormatType enum
  String formatByType(DateFormatType type) {
    switch (type) {
      case DateFormatType.mediumDate:
        return mediumDate;
      case DateFormatType.longDate:
        return longDate;
      case DateFormatType.shortDate:
        return shortDate;
      case DateFormatType.isoDate:
        return isoDate;
      case DateFormatType.fullDate:
        return fullDate;
      case DateFormatType.abbrevDate:
        return abbrevDate;
      case DateFormatType.monthYear:
        return monthYear;
      case DateFormatType.abbrevMonthYear:
        return abbrevMonthYear;
      case DateFormatType.numericMonthYear:
        return numericMonthYear;
      case DateFormatType.monthDay:
        return monthDay;
      case DateFormatType.abbrevMonthDay:
        return abbrevMonthDay;
      case DateFormatType.numericMonthDay:
        return numericMonthDay;
      case DateFormatType.weekday:
        return weekday;
      case DateFormatType.abbrevWeekday:
        return abbrevWeekday;
      case DateFormatType.weekdayMonthDay:
        return weekdayMonthDay;
      case DateFormatType.year:
        return year;
      case DateFormatType.shortYear:
        return shortYear;
      case DateFormatType.dashedDate:
        return dashedDate;
      case DateFormatType.dottedDate:
        return dottedDate;
      case DateFormatType.dateWithOrdinal:
        return dateWithOrdinal;
    }
  }

  @override
  String toString() => isoDate;
}
