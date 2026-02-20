import 'dart:convert';

import 'package:win95_launcher/main.dart';

import 'package:win95_launcher/models/app_alignment.dart';
import 'package:win95_launcher/models/gesture_action.dart';

import 'package:win95_launcher/constants/storage_keys/settings_pref_keys.dart';

class AppSettingsPref {
  static void setShowStatusBar(bool value) {
    App.localStorage.setBool(showStatusBar, value);
  }

  static bool getShowStatusBar() {
    return App.localStorage.getBool(showStatusBar) ?? true;
  }

  static void setTextSize(double size) {
    App.localStorage.setDouble(textSize, size);
  }

  static double getTextSize() {
    return App.localStorage.getDouble(textSize) ?? 18;
  }

  static void setShortcutNum(int amount) {
    App.localStorage.setInt(shortcutNum, amount);
  }

  static int getShortcutNum() {
    return App.localStorage.getInt(shortcutNum) ?? 4;
  }

  static void setAutoShowKeyboard(bool value) {
    App.localStorage.setBool(autoShowKeyboard, value);
  }

  static bool getAutoShowKeyboard() {
    return App.localStorage.getBool(autoShowKeyboard) ?? true;
  }

  static void setRotationPermission(bool value) {
    App.localStorage.setBool(allowRotation, value);
  }

  static bool getRotationPermission() {
    return App.localStorage.getBool(allowRotation) ?? true;
  }

  static void setHomeAppAlignment(AppAlignment alignment) {
    App.localStorage.setString(homeAppAlignment, alignment.toString());
  }

  static AppAlignment getHomeAppAlignment() {
    final alignment = App.localStorage.getString(homeAppAlignment) ?? 'Center';
    return AppAlignment.values.firstWhere((e) => e.toString() == alignment);
  }

  static void setHomeAppAlignBottom(bool value) {
    App.localStorage.setBool(homeAlignBottom, value);
  }

  static bool getHomeAppAlignBottom() {
    return App.localStorage.getBool(homeAlignBottom) ?? false;
  }

  static void setAppListAlignment(AppAlignment alignment) {
    App.localStorage.setString(appListAlignment, alignment.toString());
  }

  static AppAlignment getAppListAlignment() {
    final alignment = App.localStorage.getString(appListAlignment) ?? 'Center';
    return AppAlignment.values.firstWhere((e) => e.toString() == alignment);
  }

  static void setLeftSwipeAction(GestureAction action) {
    App.localStorage.setString(leftSwipeAction, action.toJson().toString());
  }

  static GestureAction getLeftSwipeAction() {
    final action = App.localStorage.getString(leftSwipeAction);
    if (action != null) return GestureAction.fromJson(json.decode(action));
    return GestureAction.camera();
  }

  static void setRightSwipeAction(GestureAction action) {
    App.localStorage.setString(rightSwipeAction, action.toJson().toString());
  }

  static GestureAction getRightSwipeAction() {
    final action = App.localStorage.getString(rightSwipeAction);
    if (action != null) return GestureAction.fromJson(json.decode(action));
    return GestureAction.phone();
  }

  static void setUpSwipeAction(GestureAction action) {
    App.localStorage.setString(upSwipeAction, action.toJson().toString());
  }

  static GestureAction getUpSwipeAction() {
    final action = App.localStorage.getString(upSwipeAction);
    if (action != null) return GestureAction.fromJson(json.decode(action));
    return GestureAction.showAppList();
  }

  static void setDownSwipeAction(GestureAction action) {
    App.localStorage.setString(downSwipeAction, action.toJson().toString());
  }

  static GestureAction getDownSwipeAction() {
    final action = App.localStorage.getString(downSwipeAction);
    if (action != null) return GestureAction.fromJson(json.decode(action));
    return GestureAction.showNotifications();
  }

  static void setDoubleTapAction(GestureAction action) {
    App.localStorage.setString(doubleTapAction, action.toJson().toString());
  }

  static GestureAction getDoubleTapAction() {
    final action = App.localStorage.getString(doubleTapAction);
    if (action != null) return GestureAction.fromJson(json.decode(action));
    return GestureAction.lockScreen();
  }
}
