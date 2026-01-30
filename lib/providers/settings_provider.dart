import 'package:flutter/material.dart';

import 'package:win95_launcher/models/app_alignment.dart';

// TODO: Save Settings to SharedPref  with App.localStorage

class SettingsProvider with ChangeNotifier {
  // Appearance
  bool _showStatusBar = true;
  double _textSize = 18;
  int _shortcutNum = 4;
  // Behavior
  bool _autoShowKeyboard = true;
  // Alignment
  AppAlignment _homeAppAlignment = AppAlignment.center;
  bool _homeAppBottom = false;
  AppAlignment _appListAlignment = AppAlignment.center;
  // Gesture

  // ===========================

  // Appearance
  bool get showStatusBar => _showStatusBar;
  double get textSize => _textSize;
  int get shortcutNum => _shortcutNum;
  // Behavior
  bool get autoShowKeyboard => _autoShowKeyboard;
  // Alignment
  AppAlignment get homeAppAlignment => _homeAppAlignment;
  bool get homeAppBottom => _homeAppBottom;
  AppAlignment get appListAlignment => _appListAlignment;
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

  void setHomeAppAlignment(AppAlignment value) {
    _homeAppAlignment = value;
    notifyListeners();
  }

  void setHomeAppBottom(bool value) {
    _homeAppBottom = value;
    notifyListeners();
  }

  void setAppListAlignment(AppAlignment value) {
    _appListAlignment = value;
    notifyListeners();
  }
}
