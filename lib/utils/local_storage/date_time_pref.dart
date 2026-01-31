import 'package:win95_launcher/main.dart';

import 'package:win95_launcher/models/time_format.dart';
import 'package:win95_launcher/models/date_format.dart';

import 'package:win95_launcher/constants/storage_keys/date_time_pref_keys.dart';

class DateTimePref {
  static void setShowTime(bool value) {
    App.localStorage.setBool(showTime, value);
  }

  static bool getShowTime() {
    return App.localStorage.getBool(showTime) ?? true;
  }

  static void setShowDate(bool value) {
    App.localStorage.setBool(showDate, value);
  }

  static bool getShowDate() {
    return App.localStorage.getBool(showDate) ?? true;
  }

  static void setTimeFormat(TimeFormatType format) {
    App.localStorage.setString(timeFormat, format.name);
  }

  static TimeFormatType getTimeFormat() {
    final format = App.localStorage.getString(timeFormat) ?? 'time12Hour';
    return TimeFormatType.values.firstWhere((e) => e.name == format);
  }

  static void setDateFormat(DateFormatType format) {
    App.localStorage.setString(dateFormat, format.name);
  }

  static DateFormatType getDateFormat() {
    final format = App.localStorage.getString(dateFormat) ?? 'abbrevDate';
    return DateFormatType.values.firstWhere((e) => e.name == format);
  }
}
