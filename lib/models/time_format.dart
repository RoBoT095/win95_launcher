import 'package:intl/intl.dart';

// 15 Time Format Options

/// A model class that provides various time formatting options using the intl library.
class TimeFormatModel {
  final DateTime dateTime;

  TimeFormatModel(this.dateTime);

  /// Creates a TimeFormatModel from the current date/time
  factory TimeFormatModel.now() {
    return TimeFormatModel(DateTime.now());
  }

  /// Creates a TimeFormatModel from a string
  factory TimeFormatModel.parse(String dateString) {
    return TimeFormatModel(DateTime.parse(dateString));
  }

  /// Creates a TimeFormatModel from hour and minute
  factory TimeFormatModel.fromTime(int hour, int minute, [int second = 0]) {
    final now = DateTime.now();
    return TimeFormatModel(
      DateTime(now.year, now.month, now.day, hour, minute, second),
    );
  }

  // Common Time Formats

  /// Returns time in format: 2:30 PM (12-hour with AM/PM)
  String get time12Hour => DateFormat.jm().format(dateTime);

  /// Returns time in format: 14:30 (24-hour)
  String get time24Hour => DateFormat.Hm().format(dateTime);

  /// Returns time in format: 2:30:45 PM (12-hour with seconds)
  String get time12HourWithSeconds => DateFormat.jms().format(dateTime);

  /// Returns time in format: 14:30:45 (24-hour with seconds)
  String get time24HourWithSeconds => DateFormat.Hms().format(dateTime);

  // Hour Only Formats

  /// Returns hour in format: 2 PM (12-hour with AM/PM)
  String get hour12 => DateFormat.j().format(dateTime);

  /// Returns hour in format: 14 (24-hour)
  String get hour24 => DateFormat.H().format(dateTime);

  // Detailed Time Components

  /// Returns hour in 12-hour format (1-12)
  int get hour12Value {
    final hour = dateTime.hour;
    if (hour == 0) return 12;
    if (hour > 12) return hour - 12;
    return hour;
  }

  /// Returns hour in 24-hour format (0-23)
  int get hour24Value => dateTime.hour;

  /// Returns minute (0-59)
  int get minute => dateTime.minute;

  /// Returns second (0-59)
  int get second => dateTime.second;

  /// Returns AM or PM
  String get period => dateTime.hour < 12 ? 'AM' : 'PM';

  // Custom Time Formats

  /// Returns time in format: 02:30 PM (12-hour with leading zero)
  String get time12HourPadded => DateFormat('hh:mm a').format(dateTime);

  /// Returns time in format: 14:30 (24-hour with leading zero)
  String get time24HourPadded => DateFormat('HH:mm').format(dateTime);

  /// Returns time in format: 02:30:45 PM
  String get time12HourPaddedWithSeconds =>
      DateFormat('hh:mm:ss a').format(dateTime);

  /// Returns time in format: 14:30:45
  String get time24HourPaddedWithSeconds =>
      DateFormat('HH:mm:ss').format(dateTime);

  // Utility Methods

  /// Format with a custom pattern
  String format(String pattern) {
    return DateFormat(pattern).format(dateTime);
  }

  /// Returns time in format: 14:30 (uses 24-hour by default)
  @override
  String toString() => time24Hour;
}
