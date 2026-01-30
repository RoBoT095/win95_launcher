import 'package:flutter/material.dart';

// TODO: Save Settings to SharedPref with App.localStorage

class DateTimeProvider with ChangeNotifier {
  bool _showTime = true;
  bool _showDate = true;

  // ===========================

  bool get showTime => _showTime;
  bool get showDate => _showDate;

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
}
