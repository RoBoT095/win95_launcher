import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter95/flutter95.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';
import 'package:pixelarticons/pixelarticons.dart';

import 'package:win95_launcher/providers/app_list_provider.dart';
import 'package:win95_launcher/providers/settings_provider.dart';

import 'package:win95_launcher/components/app_tile.dart';

class AppList extends StatefulWidget {
  const AppList({super.key, this.onAppSelected});

  final Function(AppInfo appInfo)? onAppSelected;

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  final TextEditingController _searchController = TextEditingController();

  String? _editingPackageName;
  final TextEditingController _renameController = TextEditingController();
  bool _nameChanged = false;

  @override
  void dispose() {
    _searchController.dispose();
    _renameController.dispose();
    super.dispose();
  }

  void _startEditing(AppInfo app, String displayName) {
    setState(() {
      _editingPackageName = app.packageName;
      _renameController.text = displayName;
      _nameChanged = false;
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingPackageName = null;
      _renameController.clear();
      _nameChanged = false;
    });
  }

  void _handleRename(BuildContext context) {
    final newName = _renameController.text.trim();
    if (newName.isNotEmpty && _editingPackageName != null) {
      context.read<AppListProvider>().setCustomAppName(
        _editingPackageName!,
        newName,
      );
    }
    _cancelEditing();
  }

  void _restoreAppName(BuildContext context, AppInfo app) {
    context.read<AppListProvider>().removeCustomAppName(app.packageName!);
    _cancelEditing();
  }

  @override
  Widget build(BuildContext context) {
    final apps = context.watch<AppListProvider>().appSearchList;
    final readAppListProv = context.read<AppListProvider>();
    final watchSettings = context.watch<SettingsProvider>();
    return Elevation95(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                height: 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Flutter95.headerDark, Flutter95.headerLight],
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Image.asset(
                        'assets/icons/find.ico',
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: TextField95(
                        controller: _searchController,
                        autofocus: watchSettings.autoShowKeyboard,
                        onChanged: (value) {
                          readAppListProv.searchAppList(_searchController.text);
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Button95(
                      padding: const EdgeInsetsGeometry.symmetric(
                        horizontal: 8,
                      ),
                      height: 36,
                      child: Center(
                        child: Text(
                          'Clear',
                          style: TextStyle(fontFamily: 'W95FA'),
                        ),
                      ),
                      onTap: () {
                        _searchController.clear();
                        readAppListProv.searchAppList(_searchController.text);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification is OverscrollNotification &&
                        notification.overscroll < 0) {
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
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: apps.length,
                      itemBuilder: (context, index) {
                        final app = apps[index];
                        final displayName = readAppListProv.displayNameFor(app);
                        final isEditing =
                            _editingPackageName == app.packageName;

                        if (isEditing) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField95(
                                    controller: _renameController,
                                    autofocus: true,
                                    onChanged: (value) {
                                      final changed =
                                          value.trim() != displayName;
                                      if (changed != _nameChanged) {
                                        setState(() {
                                          _nameChanged = changed;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Tooltip95(
                                  message: _nameChanged
                                      ? 'Confirm renaming'
                                      : 'Cancel name change',
                                  child: GestureDetector(
                                    onTap: _nameChanged
                                        ? () => _handleRename(context)
                                        : _cancelEditing,
                                    child: Elevation95(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0,
                                          vertical: 4.0,
                                        ),
                                        child: Text(
                                          _nameChanged ? 'Rename' : 'Cancel',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Tooltip95(
                                  message: 'Restore app name',
                                  child: GestureDetector(
                                    onTap: () => _restoreAppName(context, app),
                                    child: Elevation95(
                                      child: Icon(Pixel.reload, size: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Tooltip95(
                                  message: 'Open apps settings/info page',
                                  child: GestureDetector(
                                    onTap: () async {
                                      _cancelEditing();
                                      await FlutterDeviceApps.openAppSettings(
                                        app.packageName!,
                                      );
                                    },
                                    child: Elevation95(
                                      child: Icon(Pixel.infobox, size: 24),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return AppListTile(
                          appInfo: app,
                          title: displayName,
                          showIcons: watchSettings.showDrawerIcons,
                          onTap: () async {
                            if (widget.onAppSelected != null) {
                              widget.onAppSelected!(app);
                              _searchController.clear();
                              readAppListProv.searchAppList(
                                _searchController.text,
                              );
                              Navigator.pop(context);
                            } else {
                              await FlutterDeviceApps.openApp(app.packageName!);
                            }
                          },
                          onLongPress: () {
                            if (widget.onAppSelected != null) {
                              return;
                            } else {
                              _startEditing(app, displayName);
                            }
                          },
                          appAlignment: watchSettings.appListAlignment
                              .toAlignment(),
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
