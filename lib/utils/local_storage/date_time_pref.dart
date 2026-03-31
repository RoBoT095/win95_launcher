import 'package:win95_launcher/main.dart';

import 'package:win95_launcher/models/time_format.dart';
import 'package:win95_launcher/models/date_format.dart';

import 'package:win95_launcher/constants/storage_keys/date_time_pref_keys.dart'
    as c;

class DateTimePref {
  static void setShowTime(bool value) {
    App.localStorage.setBool(c.showTime, value);
  }

  static bool getShowTime() {
    return App.localStorage.getBool(c.showTime) ?? true;
  }

  static void setShowDate(bool value) {
    App.localStorage.setBool(c.showDate, value);
  }

  static bool getShowDate() {
    return App.localStorage.getBool(c.showDate) ?? true;
  }

  static void setShowBattery(bool value) {
    App.localStorage.setBool(c.showBattery, value);
  }

  static bool getShowBattery() {
    return App.localStorage.getBool(c.showBattery) ?? true;
  }

  static void setTimeFormat(TimeFormatType format) {
    App.localStorage.setString(c.timeFormat, format.name);
  }

  static TimeFormatType getTimeFormat() {
    final format = App.localStorage.getString(c.timeFormat) ?? 'time12Hour';
    return TimeFormatType.values.firstWhere((e) => e.name == format);
  }

  static void setDateFormat(DateFormatType format) {
    App.localStorage.setString(c.dateFormat, format.name);
  }

  static DateFormatType getDateFormat() {
    final format = App.localStorage.getString(c.dateFormat) ?? 'abbrevDate';
    return DateFormatType.values.firstWhere((e) => e.name == format);
  }
}
