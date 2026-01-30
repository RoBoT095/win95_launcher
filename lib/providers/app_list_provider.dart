import 'package:flutter/material.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';

// TODO: Database for apps with custom names

class AppListProvider with ChangeNotifier {
  List<AppInfo> _appList = [];

  // ===========================

  List<AppInfo> get appList => _appList;

  AppListProvider() {
    loadApps();
  }

  void loadApps() async {
    final list = await FlutterDeviceApps.listApps(
      includeSystem: false,
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
    notifyListeners();
  }

  void sortAppList() {}
}
