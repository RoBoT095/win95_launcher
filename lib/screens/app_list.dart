import 'package:flutter/material.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';
import 'package:flutter95/flutter95.dart';

class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  // TODO: State to see app name editor
  late List<AppInfo> apps;
  bool _isLoading = true;

  // TODO: Move app loading to provider
  void _getAppList() async {
    final appList = await FlutterDeviceApps.listApps(
      includeSystem: false,
      onlyLaunchable: true,
      includeIcons: false,
    );
    appList.removeWhere(
      (app) => app.packageName == 'com.printnotes.win95_launcher',
    );
    setState(() {
      apps = appList;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _getAppList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Elevation95(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _isLoading
              // Look for a pixelated progress indicator
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField95(),
                    ),
                    Expanded(
                      child: NotificationListener<ScrollUpdateNotification>(
                        // FIXME: Can't scroll back up without scrolling down first
                        onNotification: (notification) {
                          if (notification.metrics.pixels <= 0 &&
                              notification.dragDetails != null) {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            return true;
                          }
                          return false;
                        },

                        child: Material(
                          color: Colors.transparent,
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            itemCount: apps.length,
                            itemBuilder: (context, index) {
                              final app = apps[index];
                              return ListTile(
                                title: Text(
                                  '${app.appName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () async {
                                  await FlutterDeviceApps.openApp(
                                    app.packageName!,
                                  );
                                },
                                onLongPress: () {
                                  // TODO: Allow to edit app name and show icon to open app details page
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
