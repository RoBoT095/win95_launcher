import 'package:flutter/material.dart';

// TODO: Save Settings to SharedPref  with App.localStorage

class SettingsProvider with ChangeNotifier {
  // Appearance
  bool _showStatusBar = true;
  double _textSize = 18;
  int _shortcutNum = 4;
  // Behavior
  bool _autoShowKeyboard = true;
  // Alignment
  String _homeAppAlignment = 'center';
  String _appListAlignment = 'center';
  // Gesture

  // ===========================

  // Appearance
  bool get showStatusBar => _showStatusBar;
  double get textSize => _textSize;
  int get shortcutNum => _shortcutNum;
  // Behavior
  bool get autoShowKeyboard => _autoShowKeyboard;
  // Alignment
  String get homeAppAlignment => _homeAppAlignment;
  String get appListAlignment => _appListAlignment;
  // Gesture

  SettingsProvider() {
    loadSettings();
  }

  void loadSettings() {}

  void setStatusBarVisibility(bool value) {
    _showStatusBar = value;
    notifyListeners();
  }

  void setTextSize(double value) {
    _textSize = value;
    notifyListeners();
  }

  void setAutoShowKeyboard(bool value) {
    _autoShowKeyboard = value;
    notifyListeners();
  }

  void setShortcutNum(int value) {
    _shortcutNum = value;
    notifyListeners();
  }

  void setHomeAppAlignment(String value) {
    _homeAppAlignment = value;
    notifyListeners();
  }

  void setAppListAlignment(String value) {
    _appListAlignment = value;
    notifyListeners();
  }
}
