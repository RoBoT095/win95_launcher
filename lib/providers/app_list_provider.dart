import 'package:flutter/material.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';
import 'package:win95_launcher/utils/local_storage/app_list_pref.dart';
import 'package:win95_launcher/constants/constants.dart' as c;

class AppListProvider with ChangeNotifier {
  List<AppInfo> _appList = [];
  List<AppInfo> _appSearchList = [];

  Map<String, String> _customAppNames = {};

  List<AppInfo?> _homeShortcutApps = List.filled(c.appShortcutMax, null);

  // ===========================

  List<AppInfo> get appList => _appList;
  List<AppInfo> get appSearchList => _appSearchList;

  String displayNameFor(AppInfo app) =>
      _customAppNames[app.packageName] ?? app.appName ?? '';

  bool hasCustomName(String packageName) =>
      _customAppNames.containsKey(packageName);

  List<AppInfo?> get homeShortcutApps => _homeShortcutApps;

  AppListProvider() {
    loadApps();
    loadStorage();
  }

  void loadStorage() {
    _homeShortcutApps = AppListPref.getHomeShortcutApps();
    _customAppNames = AppListPref.getCustomAppNames();
    notifyListeners();
  }

  void loadApps() async {
    final list = await FlutterDeviceApps.listApps(
      includeSystem: true,
      onlyLaunchable: true,
      includeIcons: false,
    );
    // Remove launcher from list
    list.removeWhere(
      (app) => app.packageName == 'com.printnotes.win95_launcher',
    );

    // Due to system apps included, need to resort list
    list.sort((a, b) {
      return a.appName!.toLowerCase().compareTo(b.appName!.toLowerCase());
    });

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
        final name = displayNameFor(app).toLowerCase();
        return name
                .replaceAll(r"[!@#$%^&*(),.?:{}|<>\/;\'[\]\-\–_=+]", '')
                .contains(query) ||
            app.packageName!.toLowerCase().contains(query);
      }).toList();
    }
    notifyListeners();
  }

  void setCustomAppName(String packageName, String newName) {
    AppListPref.setCustomAppName(packageName, newName);
    _customAppNames[packageName] = newName;
    // Re-sort _appList by display name so the list order stays correct
    _appList.sort((a, b) {
      return displayNameFor(
        a,
      ).toLowerCase().compareTo(displayNameFor(b).toLowerCase());
    });
    _appSearchList = List.of(_appList);
    notifyListeners();
  }

  void removeCustomAppName(String packageName) {
    AppListPref.removeCustomAppName(packageName);
    _customAppNames.remove(packageName);
    _appList.sort((a, b) {
      return displayNameFor(
        a,
      ).toLowerCase().compareTo(displayNameFor(b).toLowerCase());
    });
    _appSearchList = List.of(_appList);
    notifyListeners();
  }

  // TODO: Add option in settings with confirmation pop up
  void clearAllCustomAppNames() {
    AppListPref.clearAll();
    _customAppNames.clear();
    _appList.sort((a, b) {
      return a.appName!.toLowerCase().compareTo(b.appName!.toLowerCase());
    });
    _appSearchList = List.of(_appList);
    notifyListeners();
  }

  void addAppToHome(int index, String packageName) {
    final app = _appList.firstWhere((app) => app.packageName == packageName);

    _homeShortcutApps[index] = app;
    AppListPref.setHomeShortcutApps(_homeShortcutApps);
    notifyListeners();
  }

  void clearHomeShortcuts() {
    _homeShortcutApps = List.filled(c.appShortcutMax, null);
    AppListPref.setHomeShortcutApps(_homeShortcutApps);
    notifyListeners();
  }
}
