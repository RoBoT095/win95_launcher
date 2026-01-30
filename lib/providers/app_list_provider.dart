import 'package:flutter/material.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';

import 'package:win95_launcher/constants/constants.dart' as c;

// TODO: Database for apps with custom names

class AppListProvider with ChangeNotifier {
  List<AppInfo> _appList = [];
  List<AppInfo> _appSearchList = [];

  List<AppInfo?> _homeShortcutApps = List.filled(c.appShortcutMax, null);

  // ===========================

  List<AppInfo> get appList => _appList;
  List<AppInfo> get appSearchList => _appSearchList;

  List<AppInfo?> get homeShortcutApps => _homeShortcutApps;

  AppListProvider() {
    loadApps();
  }

  void loadApps() async {
    final list = await FlutterDeviceApps.listApps(
      includeSystem: true,
      onlyLaunchable: true,
      includeIcons: false,
    );
    list.removeWhere(
      (app) => app.packageName == 'com.printnotes.win95_launcher',
    );

    setAppList(list);
  }

  void setAppList(List<AppInfo> list) {
    _appList = list;
    _appSearchList = list;
    notifyListeners();
  }

  void searchAppList(String query) {
    query = query.toLowerCase();

    if (query.isEmpty) {
      _appSearchList = _appList;
    } else {
      _appSearchList = _appList.where((app) {
        return app.appName!.toLowerCase().contains(query) ||
            app.packageName!.toLowerCase().contains(query);
      }).toList();
    }
    notifyListeners();
  }

  void addAppToHome(int index, String packageName) {
    final app = _appList.firstWhere((app) => app.packageName == packageName);

    _homeShortcutApps[index] = app;
    notifyListeners();
  }

  void clearHomeShortcuts() {
    _homeShortcutApps = List.filled(c.appShortcutMax, null);
    notifyListeners();
  }
}
