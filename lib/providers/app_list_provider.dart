import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_device_apps/flutter_device_apps.dart';
import 'package:win95_launcher/utils/local_storage/app_list_pref.dart';
import 'package:win95_launcher/constants/constants.dart' as c;

class AppListProvider with ChangeNotifier {
  List<AppInfo> _appList = [];
  List<AppInfo> _appSearchList = [];

  Map<String, String> _customAppNames = {};

  List<AppInfo?> _homeShortcutApps = List.filled(c.appShortcutMax, null);

  final Map<String, Uint8List?> _iconBytes = {};

  // ===========================

  List<AppInfo> get appList => _appList;
  List<AppInfo> get appSearchList => _appSearchList;

  Map<String, String> get customAppNames => _customAppNames;

  String displayNameFor(AppInfo app) =>
      _customAppNames[app.packageName] ?? app.appName ?? '';

  bool hasCustomName(String packageName) =>
      _customAppNames.containsKey(packageName);

  List<AppInfo?> get homeShortcutApps => _homeShortcutApps;

  Uint8List? iconBytesFor(String packageName) => _iconBytes[packageName];

  Image? imageForPackage(
    String packageName, {
    bool pixelate = true,
    int? pixelationLevel = 22,
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    Uint8List? bytes = _iconBytes[packageName];
    if (bytes == null) return null;
    if (pixelate) {
      bytes = pixelateBytes(
        bytes,
        pixelationLevel,
        width?.toInt(),
        height?.toInt(),
      );
    }
    return Image.memory(bytes, width: width, height: height, fit: fit);
  }

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

    _preloadIcons(list);
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

  void _preloadIcons(List<AppInfo> list) async {
    for (final app in list) {
      final pkg = app.packageName;
      if (pkg == null) continue;
      // Skip if already loaded
      if (_iconBytes.containsKey(pkg)) continue;
      try {
        final full = await FlutterDeviceApps.getApp(pkg, includeIcon: true);
        _iconBytes[pkg] = full?.iconBytes;
        notifyListeners();
      } catch (_) {
        // If an icon fails to load, store null to avoid retrying every time
        _iconBytes[pkg] = null;
      }
    }
  }

  Uint8List pixelateBytes(
    Uint8List bytes,
    int? pixelSize,
    int? outW,
    int? outH,
  ) {
    final src = img.decodeImage(bytes);
    if (src == null) return bytes;
    final small = img.copyResize(
      src,
      width: pixelSize,
      height: pixelSize,
      interpolation: img.Interpolation.nearest,
    );
    final out = img.copyResize(
      small,
      width: outW,
      height: outH,
      interpolation: img.Interpolation.nearest,
    );
    return Uint8List.fromList(img.encodePng(out));
  }
}
