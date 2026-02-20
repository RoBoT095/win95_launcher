import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';

import 'package:win95_launcher/models/app_alignment.dart';
import 'package:win95_launcher/models/gesture_action.dart';

import 'package:win95_launcher/utils/local_storage/app_settings_pref.dart';

import 'package:win95_launcher/screens/app_list.dart';

class SettingsProvider with ChangeNotifier {
  final _channel = MethodChannel('custom_functions');

  // Appearance
  bool _showStatusBar = true;
  double _textSize = 18;
  int _shortcutNum = 4;
  // Behavior
  bool _autoShowKeyboard = true;
  bool _allowRotation = true;
  // Alignment
  AppAlignment _homeAppAlignment = AppAlignment.center;
  bool _homeAppBottom = false;
  AppAlignment _appListAlignment = AppAlignment.center;
  // Gesture
  GestureAction _leftSwipeAction = GestureAction.camera();
  GestureAction _rightSwipeAction = GestureAction.phone();
  GestureAction _upSwipeAction = GestureAction.showAppList();
  GestureAction _downSwipeAction = GestureAction.showNotifications();
  GestureAction _doubleTapAction = GestureAction.lockScreen();

  // ===========================

  // Appearance
  bool get showStatusBar => _showStatusBar;
  double get textSize => _textSize;
  int get shortcutNum => _shortcutNum;
  // Behavior
  bool get autoShowKeyboard => _autoShowKeyboard;
  bool get allowRotation => _allowRotation;
  // Alignment
  AppAlignment get homeAppAlignment => _homeAppAlignment;
  bool get homeAppBottom => _homeAppBottom;
  AppAlignment get appListAlignment => _appListAlignment;
  // Gesture
  GestureAction get leftSwipeAction => _leftSwipeAction;
  GestureAction get rightSwipeAction => _rightSwipeAction;
  GestureAction get upSwipeAction => _upSwipeAction;
  GestureAction get downSwipeAction => _downSwipeAction;
  GestureAction get doubleTapAction => _doubleTapAction;

  SettingsProvider() {
    loadSettings();
  }

  void loadSettings() {
    _showStatusBar = AppSettingsPref.getShowStatusBar();
    _textSize = AppSettingsPref.getTextSize();
    _shortcutNum = AppSettingsPref.getShortcutNum();

    _autoShowKeyboard = AppSettingsPref.getAutoShowKeyboard();
    _allowRotation = AppSettingsPref.getRotationPermission();

    _homeAppAlignment = AppSettingsPref.getHomeAppAlignment();
    _homeAppBottom = AppSettingsPref.getHomeAppAlignBottom();
    _appListAlignment = AppSettingsPref.getAppListAlignment();

    _leftSwipeAction = AppSettingsPref.getLeftSwipeAction();
    _rightSwipeAction = AppSettingsPref.getRightSwipeAction();
    _upSwipeAction = AppSettingsPref.getUpSwipeAction();
    _downSwipeAction = AppSettingsPref.getDownSwipeAction();
    _doubleTapAction = AppSettingsPref.getDoubleTapAction();

    notifyListeners();
  }

  void setStatusBarVisibility(bool value) {
    _showStatusBar = value;
    AppSettingsPref.setShowStatusBar(value);
    notifyListeners();
  }

  void setTextSize(double value) {
    _textSize = value;
    AppSettingsPref.setTextSize(value);
    notifyListeners();
  }

  void setAutoShowKeyboard(bool value) {
    _autoShowKeyboard = value;
    AppSettingsPref.setAutoShowKeyboard(value);
    notifyListeners();
  }

  void setRotationPermission(bool value) {
    _allowRotation = value;
    AppSettingsPref.setRotationPermission(value);
    notifyListeners();
  }

  void setShortcutNum(int value) {
    _shortcutNum = value;
    AppSettingsPref.setShortcutNum(value);
    notifyListeners();
  }

  void setHomeAppAlignment(AppAlignment value) {
    _homeAppAlignment = value;
    AppSettingsPref.setHomeAppAlignment(value);
    notifyListeners();
  }

  void setHomeAppBottom(bool value) {
    _homeAppBottom = value;
    AppSettingsPref.setHomeAppAlignBottom(value);
    notifyListeners();
  }

  void setAppListAlignment(AppAlignment value) {
    _appListAlignment = value;
    AppSettingsPref.setAppListAlignment(value);
    notifyListeners();
  }

  void setLeftSwipeAction(GestureAction value) {
    _leftSwipeAction = value;
    AppSettingsPref.setLeftSwipeAction(value);
    notifyListeners();
  }

  void setRightSwipeAction(GestureAction value) {
    _rightSwipeAction = value;
    AppSettingsPref.setRightSwipeAction(value);
    notifyListeners();
  }

  void setUpSwipeAction(GestureAction value) {
    _upSwipeAction = value;
    AppSettingsPref.setUpSwipeAction(value);
    notifyListeners();
  }

  void setDownSwipeAction(GestureAction value) {
    _downSwipeAction = value;
    AppSettingsPref.setDownSwipeAction(value);
    notifyListeners();
  }

  void setDoubleTapAction(GestureAction value) {
    _doubleTapAction = value;
    AppSettingsPref.setDoubleTapAction(value);
    notifyListeners();
  }

  // Gesture executions

  void executeLeftSwipe(BuildContext context) {
    executeGestureAction(context, _leftSwipeAction);
  }

  void executeRightSwipe(BuildContext context) {
    executeGestureAction(context, _rightSwipeAction);
  }

  void executeUpSwipe(BuildContext context) {
    executeGestureAction(context, _upSwipeAction);
  }

  void executeDownSwipe(BuildContext context) {
    executeGestureAction(context, _downSwipeAction);
  }

  void executeDoubleTap(BuildContext context) {
    executeGestureAction(context, _doubleTapAction);
  }

  void executeGestureAction(BuildContext context, GestureAction action) {
    switch (action.type) {
      case GestureActionType.disabled:
        break;
      case GestureActionType.camera:
        openCamera();
        break;
      case GestureActionType.phone:
        openPhone();
        break;
      case GestureActionType.clock:
        openClock();
        break;
      case GestureActionType.calendar:
        openCalendar();
        break;
      case GestureActionType.openApp:
        if (action.appPackageName != null) {
          openCustomApp(action.appPackageName!);
        }
        break;
      case GestureActionType.lockScreen:
        lockScreen();
        break;
      case GestureActionType.showAppList:
        showAppList(context);
        break;
      case GestureActionType.showNotifications:
        openNotificationPanel();
        break;
    }
  }

  // Open defaults

  void openLauncherChooser() async {
    await _channel.invokeMethod('openLauncherChooser');
  }

  void openNotificationPanel() async {
    await _channel.invokeMethod('openNotificationPanel');
  }

  void lockScreen() async {
    await _channel.invokeMethod('lockScreen');
  }

  void showAppList(
    BuildContext context, {
    Function(AppInfo appInfo)? onAppSelected,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AppList(onAppSelected: onAppSelected),
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  void openCustomApp(String packageName) async {
    final intent = AndroidIntent(package: packageName, componentName: '');
    await intent.launch();
  }

  void openCamera() {
    const intent = AndroidIntent(
      action: 'android.media.action.STILL_IMAGE_CAMERA',
    );
    intent.launch();
  }

  void openPhone() {
    const intent = AndroidIntent(action: 'android.intent.action.DIAL');
    intent.launch();
  }

  void openClock() {
    const intent = AndroidIntent(action: 'android.intent.action.SHOW_ALARMS');
    intent.launch();
  }

  void openCalendar() {
    const intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'content://com.android.calendar/time/',
    );
    intent.launch();
  }
}
