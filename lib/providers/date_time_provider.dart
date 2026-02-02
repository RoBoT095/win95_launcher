import 'package:flutter/material.dart';

import 'package:win95_launcher/models/time_format.dart';
import 'package:win95_launcher/models/date_format.dart';

import 'package:win95_launcher/utils/local_storage/date_time_pref.dart';

class DateTimeProvider with ChangeNotifier {
  bool _showTime = true;
  bool _showDate = true;
  bool _showBattery = true;
  TimeFormatType _timeFormat = TimeFormatType.time12HourPaddedWithSeconds;
  DateFormatType _dateFormat = DateFormatType.abbrevDate;

  // ===========================

  bool get showTime => _showTime;
  bool get showDate => _showDate;
  bool get showBattery => _showBattery;
  TimeFormatType get timeFormat => _timeFormat;
  DateFormatType get dateFormat => _dateFormat;

  DateTimeProvider() {
    loadSettings();
  }

  void loadSettings() {
    _showTime = DateTimePref.getShowTime();
    _showDate = DateTimePref.getShowDate();
    _showBattery = DateTimePref.getShowBattery();
    _timeFormat = DateTimePref.getTimeFormat();
    _dateFormat = DateTimePref.getDateFormat();

    notifyListeners();
  }

  void setShowTime(bool value) {
    _showTime = value;
    DateTimePref.setShowTime(value);
    notifyListeners();
  }

  void setShowDate(bool value) {
    _showDate = value;
    DateTimePref.setShowDate(value);
    notifyListeners();
  }

  void setShowBattery(bool value) {
    _showBattery = value;
    DateTimePref.setShowBattery(value);
    notifyListeners();
  }

  void setTimeFormat(TimeFormatType value) {
    _timeFormat = value;
    DateTimePref.setTimeFormat(value);
    notifyListeners();
  }

  void setDateFormat(DateFormatType value) {
    _dateFormat = value;
    DateTimePref.setDateFormat(value);
    notifyListeners();
  }
}
