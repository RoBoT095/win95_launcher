import 'package:flutter/material.dart';
import 'package:win95_launcher/models/time_format.dart';
import 'package:win95_launcher/models/date_format.dart';

// TODO: Save Settings to SharedPref with App.localStorage

class DateTimeProvider with ChangeNotifier {
  bool _showTime = true;
  bool _showDate = true;
  TimeFormatType _timeFormat = TimeFormatType.time12HourPaddedWithSeconds;
  DateFormatType _dateFormat = DateFormatType.abbrevDate;

  // ===========================

  bool get showTime => _showTime;
  bool get showDate => _showDate;
  TimeFormatType get timeFormat => _timeFormat;
  DateFormatType get dateFormat => _dateFormat;

  DateTimeProvider() {
    loadSettings();
  }

  void loadSettings() {}

  void setShowTime(bool value) {
    _showTime = value;
    notifyListeners();
  }

  void setShowDate(bool value) {
    _showDate = value;
    notifyListeners();
  }

  void setTimeFormat(TimeFormatType value) {
    _timeFormat = value;
    notifyListeners();
  }

  void setDateFormat(DateFormatType value) {
    _dateFormat = value;
    notifyListeners();
  }
}
