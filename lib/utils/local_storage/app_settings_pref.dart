import 'dart:convert';

import 'package:win95_launcher/main.dart';

import 'package:win95_launcher/models/app_alignment.dart';
import 'package:win95_launcher/models/gesture_action.dart';

import 'package:win95_launcher/constants/storage_keys/settings_pref_keys.dart'
    as c;

class AppSettingsPref {
  static void setShowStatusBar(bool value) {
    App.localStorage.setBool(c.showStatusBar, value);
  }

  static bool getShowStatusBar() {
    return App.localStorage.getBool(c.showStatusBar) ?? true;
  }

  static void setTextSize(double size) {
    App.localStorage.setDouble(c.textSize, size);
  }

  static double getTextSize() {
    return App.localStorage.getDouble(c.textSize) ?? 18;
  }

  static void setShortcutNum(int amount) {
    App.localStorage.setInt(c.shortcutNum, amount);
  }

  static int getShortcutNum() {
    return App.localStorage.getInt(c.shortcutNum) ?? 4;
  }

  static void setShowHomeIcons(bool value) {
    App.localStorage.setBool(c.showHomeIcons, value);
  }

  static bool getShowHomeIcons() {
    return App.localStorage.getBool(c.showHomeIcons) ?? true;
  }

  static void setShowDrawerIcons(bool value) {
    App.localStorage.setBool(c.showDrawerIcons, value);
  }

  static bool getShowDrawerIcons() {
    return App.localStorage.getBool(c.showDrawerIcons) ?? true;
  }

  static void setPixelateIcons(bool value) {
    App.localStorage.setBool(c.pixelateIcons, value);
  }

  static bool getPixelateIcons() {
    return App.localStorage.getBool(c.pixelateIcons) ?? true;
  }

  static void setPixelationLevel(int value) {
    App.localStorage.setInt(c.pixelationLevel, value);
  }

  static int getPixelationLevel() {
    return App.localStorage.getInt(c.pixelationLevel) ?? 22;
  }

  static void setAutoShowKeyboard(bool value) {
    App.localStorage.setBool(c.autoShowKeyboard, value);
  }

  static bool getAutoShowKeyboard() {
    return App.localStorage.getBool(c.autoShowKeyboard) ?? true;
  }

  static void setRotationPermission(bool value) {
    App.localStorage.setBool(c.allowRotation, value);
  }

  static bool getRotationPermission() {
    return App.localStorage.getBool(c.allowRotation) ?? true;
  }

  static void setHomeAppAlignment(AppAlignment alignment) {
    App.localStorage.setString(c.homeAppAlignment, alignment.toString());
  }

  static AppAlignment getHomeAppAlignment() {
    final alignment =
        App.localStorage.getString(c.homeAppAlignment) ?? 'Center';
    return AppAlignment.values.firstWhere((e) => e.toString() == alignment);
  }

  static void setHomeAppAlignBottom(bool value) {
    App.localStorage.setBool(c.homeAlignBottom, value);
  }

  static bool getHomeAppAlignBottom() {
    return App.localStorage.getBool(c.homeAlignBottom) ?? false;
  }

  static void setAppListAlignment(AppAlignment alignment) {
    App.localStorage.setString(c.appListAlignment, alignment.toString());
  }

  static AppAlignment getAppListAlignment() {
    final alignment =
        App.localStorage.getString(c.appListAlignment) ?? 'Center';
    return AppAlignment.values.firstWhere((e) => e.toString() == alignment);
  }

  static void setLeftSwipeAction(GestureAction action) {
    App.localStorage.setString(c.leftSwipeAction, action.toJson().toString());
  }

  static GestureAction getLeftSwipeAction() {
    final action = App.localStorage.getString(c.leftSwipeAction);
    if (action != null) return GestureAction.fromJson(json.decode(action));
    return GestureAction.camera();
  }

  static void setRightSwipeAction(GestureAction action) {
    App.localStorage.setString(c.rightSwipeAction, action.toJson().toString());
  }

  static GestureAction getRightSwipeAction() {
    final action = App.localStorage.getString(c.rightSwipeAction);
    if (action != null) return GestureAction.fromJson(json.decode(action));
    return GestureAction.phone();
  }

  static void setUpSwipeAction(GestureAction action) {
    App.localStorage.setString(c.upSwipeAction, action.toJson().toString());
  }

  static GestureAction getUpSwipeAction() {
    final action = App.localStorage.getString(c.upSwipeAction);
    if (action != null) return GestureAction.fromJson(json.decode(action));
    return GestureAction.showAppList();
  }

  static void setDownSwipeAction(GestureAction action) {
    App.localStorage.setString(c.downSwipeAction, action.toJson().toString());
  }

  static GestureAction getDownSwipeAction() {
    final action = App.localStorage.getString(c.downSwipeAction);
    if (action != null) return GestureAction.fromJson(json.decode(action));
    return GestureAction.showNotifications();
  }

  static void setDoubleTapAction(GestureAction action) {
    App.localStorage.setString(c.doubleTapAction, action.toJson().toString());
  }

  static GestureAction getDoubleTapAction() {
    final action = App.localStorage.getString(c.doubleTapAction);
    if (action != null) return GestureAction.fromJson(json.decode(action));
    return GestureAction.lockScreen();
  }
}
