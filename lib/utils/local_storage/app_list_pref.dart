import 'dart:convert';

import 'package:flutter_device_apps/flutter_device_apps.dart';

import 'package:win95_launcher/main.dart';

import 'package:win95_launcher/constants/storage_keys/app_list_pref_keys.dart';
import 'package:win95_launcher/constants/constants.dart' as c;

class AppListPref {
  static void setHomeShortcutApps(List<AppInfo?> appList) {
    final jsonList = appList.map((app) => app?.toMap()).toList();
    App.localStorage.setString(homeShortcutApps, json.encode(jsonList));
  }

  static List<AppInfo?> getHomeShortcutApps() {
    final jsonString = App.localStorage.getString(homeShortcutApps);
    if (jsonString == null) {
      return List.filled(c.appShortcutMax, null);
    }
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((item) {
      if (item == null) return null;
      return AppInfo.fromMap(item as Map<String, Object?>);
    }).toList();
  }
}
