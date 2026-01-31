import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter95/flutter95.dart';
import 'package:pixelarticons/pixel.dart';
import 'package:win95_launcher/models/gesture_action.dart';

import 'package:win95_launcher/providers/settings_provider.dart';

import 'package:win95_launcher/models/app_alignment.dart';

import 'package:win95_launcher/constants/constants.dart' as c;

import 'package:win95_launcher/components/header_text_widget.dart';
import 'package:win95_launcher/components/tile_counter.dart';
import 'package:win95_launcher/components/tile_item_95.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  bool _editingTextSize = false;
  bool _editingShortcutNum = false;

  @override
  Widget build(BuildContext context) {
    final readSettings = context.read<SettingsProvider>();
    final watchSettings = context.watch<SettingsProvider>();

    return Scaffold95(
      title: 'Settings',
      onClosePressed: (val) {
        Navigator.pop(context);
      },
      body: Elevation95(
        child: Material(
          color: Colors.transparent,
          child: ListView(
            shrinkWrap: true,
            children: [
              headerText('Appearance'),
              Divider95(),
              ListTile(
                leading: Icon(Pixel.batteryfull),
                title: Text('Show top status bar'),
                trailing: Checkbox95(
                  value: watchSettings.showStatusBar,
                  onChanged: (value) {
                    readSettings.setStatusBarVisibility(value);
                    SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.manual,
                      overlays: value
                          ? SystemUiOverlay.values
                          : [SystemUiOverlay.bottom],
                    );
                  },
                ),
              ),
              _editingTextSize
                  ? TileCounter(
                      initialValue: watchSettings.textSize,
                      minValue: c.textSizeMin,
                      maxValue: c.textSizeMax,
                      onSave: (value) {
                        readSettings.setTextSize(value);
                        setState(() => _editingTextSize = !_editingTextSize);
                      },
                    )
                  : ListTile(
                      leading: Icon(Pixel.arrowsvertical),
                      title: Text('Text Size'),
                      trailing: tileItem95(
                        label: watchSettings.textSize.toInt().toString(),
                        onTap: (context) => setState(
                          () => _editingTextSize = !_editingTextSize,
                        ),
                      ),
                    ),
              _editingShortcutNum
                  ? TileCounter(
                      initialValue: watchSettings.shortcutNum.toDouble(),
                      minValue: c.appShortcutMin.toDouble(),
                      maxValue: c.appShortcutMax.toDouble(),
                      onSave: (value) {
                        readSettings.setShortcutNum(value.toInt());
                        setState(
                          () => _editingShortcutNum = !_editingShortcutNum,
                        );
                      },
                    )
                  : ListTile(
                      leading: Icon(Pixel.viewlist),
                      title: Text('Number of shortcuts'),
                      trailing: tileItem95(
                        label: watchSettings.shortcutNum.toString(),
                        onTap: (context) => setState(
                          () => _editingShortcutNum = !_editingShortcutNum,
                        ),
                      ),
                    ),
              Divider95(),
              headerText('Behavior'),
              Divider95(),
              ListTile(
                leading: Icon(Pixel.keyboard),
                title: Text('Auto show keyboard'),
                trailing: Checkbox95(
                  value: watchSettings.autoShowKeyboard,
                  onChanged: (value) => readSettings.setAutoShowKeyboard(value),
                ),
              ),
              Divider95(),
              headerText('Alignment'),
              Divider95(),
              ListTile(
                leading: Icon(Pixel.bullseyearrow),
                title: Text('Apps home screen'),
                trailing: tileItem95(
                  label: readSettings.homeAppAlignment.toString(),
                  menu: Menu95(
                    items: [
                      MenuItem95(
                        value: AppAlignment.left,
                        label: AppAlignment.left.toString(),
                      ),
                      MenuItem95(
                        value: AppAlignment.center,
                        label: AppAlignment.center.toString(),
                      ),
                      MenuItem95(
                        value: AppAlignment.right,
                        label: AppAlignment.right.toString(),
                      ),
                    ],
                    onItemSelected: (value) {
                      if (value != null && value != '') {
                        readSettings.setHomeAppAlignment(value);
                      }
                    },
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Pixel.layoutalignbottom),
                title: Text('App home screen bottom'),
                trailing: Checkbox95(
                  value: watchSettings.homeAppBottom,
                  onChanged: (value) => readSettings.setHomeAppBottom(value),
                ),
              ),
              ListTile(
                leading: Icon(Pixel.list),
                title: Text('Apps in drawer'),
                trailing: tileItem95(
                  label: readSettings.appListAlignment.toString(),
                  menu: Menu95(
                    items: [
                      MenuItem95(
                        value: AppAlignment.left,
                        label: AppAlignment.left.toString(),
                      ),
                      MenuItem95(
                        value: AppAlignment.center,
                        label: AppAlignment.center.toString(),
                      ),
                      MenuItem95(
                        value: AppAlignment.right,
                        label: AppAlignment.right.toString(),
                      ),
                    ],
                    onItemSelected: (value) {
                      if (value != null && value != '') {
                        readSettings.setAppListAlignment(value);
                      }
                    },
                  ),
                ),
              ),
              Divider95(),
              headerText('Gestures'),
              Divider95(),
              ListTile(
                leading: Icon(Pixel.arrowleftbox),
                title: Text('Swipe left'),
                trailing: tileItem95(
                  width: 150,
                  label: readSettings.leftSwipeAction.displayName,
                  menu: Menu95(
                    items: gestureMenuItems,
                    onItemSelected: (action) {
                      if (action != null && action != '') {
                        if (action.type == GestureActionType.openApp) {
                          readSettings.showAppList(
                            context,
                            onAppSelected: (appInfo) =>
                                readSettings.setLeftSwipeAction(
                                  GestureAction.openApp(
                                    appInfo.packageName!,
                                    appInfo.appName!,
                                  ),
                                ),
                          );
                        } else {
                          readSettings.setLeftSwipeAction(action);
                        }
                      }
                    },
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Pixel.arrowrightbox),
                title: Text('Swipe right'),
                trailing: tileItem95(
                  width: 150,
                  label: readSettings.rightSwipeAction.displayName,
                  menu: Menu95(
                    items: gestureMenuItems,
                    onItemSelected: (action) {
                      if (action != null && action != '') {
                        if (action.type == GestureActionType.openApp) {
                          readSettings.showAppList(
                            context,
                            onAppSelected: (appInfo) =>
                                readSettings.setLeftSwipeAction(
                                  GestureAction.openApp(
                                    appInfo.packageName!,
                                    appInfo.appName!,
                                  ),
                                ),
                          );
                        } else {
                          readSettings.setRightSwipeAction(action);
                        }
                      }
                    },
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Pixel.arrowupbox),
                title: Text('Swipe Up'),
                trailing: tileItem95(
                  width: 150,
                  label: readSettings.upSwipeAction.displayName,
                  menu: Menu95(
                    items: gestureMenuItems,
                    onItemSelected: (action) {
                      if (action != null && action != '') {
                        if (action.type == GestureActionType.openApp) {
                          readSettings.showAppList(
                            context,
                            onAppSelected: (appInfo) =>
                                readSettings.setLeftSwipeAction(
                                  GestureAction.openApp(
                                    appInfo.packageName!,
                                    appInfo.appName!,
                                  ),
                                ),
                          );
                        } else {
                          readSettings.setUpSwipeAction(action);
                        }
                      }
                    },
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Pixel.addboxmultiple),
                title: Text('Double Tap'),
                trailing: tileItem95(
                  width: 150,
                  label: readSettings.doubleTapAction.displayName,
                  menu: Menu95(
                    items: gestureMenuItems,
                    onItemSelected: (action) {
                      if (action != null && action != '') {
                        if (action.type == GestureActionType.openApp) {
                          readSettings.showAppList(
                            context,
                            onAppSelected: (appInfo) =>
                                readSettings.setLeftSwipeAction(
                                  GestureAction.openApp(
                                    appInfo.packageName!,
                                    appInfo.appName!,
                                  ),
                                ),
                          );
                        } else {
                          readSettings.setDoubleTapAction(action);
                        }
                      }
                    },
                  ),
                ),
              ),
              Divider95(),
            ],
          ),
        ),
      ),
    );
  }

  List<MenuItem95> gestureMenuItems = [
    MenuItem95(
      value: GestureAction.disabled(),
      label: GestureAction.disabled().displayName,
    ),
    MenuItem95(
      value: GestureAction.openApp('', ''),
      label: GestureAction.openApp('', '').displayName,
    ),
    MenuItem95(
      value: GestureAction.lockScreen(),
      label: GestureAction.lockScreen().displayName,
    ),
    MenuItem95(
      value: GestureAction.showAppList(),
      label: GestureAction.showAppList().displayName,
    ),
  ];
}
