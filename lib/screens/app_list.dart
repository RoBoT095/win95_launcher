import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter95/flutter95.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';

import 'package:win95_launcher/providers/app_list_provider.dart';
import 'package:win95_launcher/providers/settings_provider.dart';

class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  final TextEditingController _searchController = TextEditingController();
  // TODO: State to see app name editor

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apps = context.watch<AppListProvider>().appList;
    final watchSettings = context.watch<SettingsProvider>();
    return Elevation95(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField95(
                  controller: _searchController,
                  autofocus: watchSettings.autoShowKeyboard,
                ),
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
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: watchSettings.textSize,
                            ),
                            textAlign: watchSettings.appListAlignment
                                .toTextAlign(),
                          ),
                          onTap: () async {
                            await FlutterDeviceApps.openApp(app.packageName!);
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
