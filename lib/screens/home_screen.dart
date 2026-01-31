import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter95/flutter95.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:win95_launcher/models/gesture_action.dart';

import 'package:win95_launcher/providers/app_list_provider.dart';
import 'package:win95_launcher/providers/date_time_provider.dart';
import 'package:win95_launcher/providers/settings_provider.dart';

import 'package:win95_launcher/models/app_alignment.dart';
import 'package:win95_launcher/models/time_format.dart';
import 'package:win95_launcher/models/date_format.dart';
import 'package:win95_launcher/animations/window_transition.dart';

import 'package:win95_launcher/screens/settings/date_time.dart';
import 'package:win95_launcher/screens/settings/app_settings.dart';
import 'package:win95_launcher/screens/settings/info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _time = '';
  String _date = '';
  Timer? _timer;
  List<String> settingsList = [
    'setDefault',
    'dateTime',
    'appSettings',
    'infoPage',
  ];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: context.read<SettingsProvider>().showStatusBar
          ? SystemUiOverlay.values
          : [SystemUiOverlay.bottom],
    );

    _getTimeAndDate();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _getTimeAndDate(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getTimeAndDate() {
    final readDTProvider = context.read<DateTimeProvider>();

    final DateTime now = DateTime.now();
    final timeModel = TimeFormatModel(now);
    final dateModel = DateFormatModel(now);

    final String formattedTime = timeModel.formatByType(
      readDTProvider.timeFormat,
    );
    final String formattedDate = dateModel.formatByType(
      readDTProvider.dateFormat,
    );

    setState(() {
      _time = formattedTime;
      _date = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final readDTProvider = context.read<DateTimeProvider>();
    final readSettings = context.read<SettingsProvider>();
    final watchSettings = context.watch<SettingsProvider>();
    final readAppList = context.read<AppListProvider>();
    final watchAppList = context.watch<AppListProvider>();

    String getHeaderTimeDate() {
      final showTime = readDTProvider.showTime;
      final showDate = readDTProvider.showDate;
      if (showTime && showDate) {
        return '$_time | $_date';
      }
      return showTime
          ? _time
          : showDate
          ? _date
          : '';
    }

    return Scaffold95(
      title: getHeaderTimeDate(),
      toolbar: Toolbar95(
        actions: [
          Item95(
            label: 'Settings ',
            menu: Menu95(
              items: [
                MenuItem95(
                  value: settingsList[0],
                  label: 'Set Default Launcher',
                ),
                MenuItem95(value: settingsList[1], label: 'Format Clock/Date'),
                MenuItem95(value: settingsList[2], label: 'App Settings'),
                MenuItem95(value: settingsList[3], label: 'About'),
              ],
              onItemSelected: (value) {
                if (value == settingsList[0]) {
                  // Set default launcher
                  readSettings.openLauncherChooser();
                }
                if (value == settingsList[1]) {
                  // Date/Time settings screen
                  Navigator.push(
                    context,
                    Windows95PageRoute(page: DateTimeSettings()),
                  );
                }
                if (value == settingsList[2]) {
                  // App settings
                  Navigator.push(
                    context,
                    Windows95PageRoute(page: AppSettings()),
                  );
                }
                if (value == settingsList[3]) {
                  // Info page
                  Navigator.push(context, Windows95PageRoute(page: InfoPage()));
                }
              },
            ),
          ),
          Item95(
            label: ' Clock ',
            onTap: (context) => runTransition(
              direction: Windows95Direction.topLeft,
              onAction: () => readSettings.openClock(),
            ),
          ),
          Item95(
            label: ' Calendar ',
            onTap: (context) => runTransition(
              direction: Windows95Direction.topLeft,
              onAction: () => readSettings.openCalendar(),
            ),
          ),
        ],
      ),
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SwipeDetector(
            onSwipeLeft: (offset) {
              readSettings.leftSwipeAction.type == GestureActionType.disabled
                  ? null
                  : runTransition(
                      direction: Windows95Direction.right,
                      onAction: () => readSettings.executeLeftSwipe(context),
                    );
            },
            onSwipeRight: (offset) {
              readSettings.rightSwipeAction.type == GestureActionType.disabled
                  ? null
                  : runTransition(
                      direction: Windows95Direction.left,
                      onAction: () => readSettings.executeRightSwipe(context),
                    );
            },
            onSwipeUp: (offset) {
              readSettings.upSwipeAction.type == GestureActionType.disabled
                  ? null
                  : runTransition(
                      direction: Windows95Direction.bottomCenter,
                      onAction: () => readSettings.executeUpSwipe(context),
                    );
            },
            onSwipeDown: (offset) {
              readSettings.downSwipeAction.type == GestureActionType.disabled
                  ? null
                  : readSettings.openNotificationPanel();
            },
            child: GestureDetector(
              onDoubleTap: () =>
                  readSettings.doubleTapAction.type ==
                      GestureActionType.disabled
                  ? null
                  : runTransition(
                      direction: Windows95Direction.center,
                      onAction: () => readSettings.executeDoubleTap(context),
                    ),
              child: Elevation95(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    alignment: watchSettings.homeAppBottom
                        ? BottomAppAlignment(
                            watchSettings.homeAppAlignment,
                          ).toAlignment
                        : watchSettings.homeAppAlignment.toAlignment(),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: watchSettings.shortcutNum.toInt(),
                      itemBuilder: (context, index) {
                        AppInfo? app = watchAppList.homeShortcutApps[index];
                        return ListTile(
                          title: Text(
                            app != null
                                ? app.appName.toString()
                                : 'Add App ${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: watchSettings.textSize,
                            ),
                            textAlign: watchSettings.homeAppAlignment
                                .toTextAlign(),
                          ),
                          onTap: () async {
                            app != null
                                ? await FlutterDeviceApps.openApp(
                                    app.packageName!,
                                  )
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Long press to select app',
                                      ),
                                    ),
                                  );
                          },
                          onLongPress: () {
                            readSettings.showAppList(
                              context,
                              onAppSelected: (appInfo) {
                                readAppList.addAppToHome(
                                  index,
                                  appInfo.packageName!,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void runTransition({
    required Function() onAction,
    Windows95Direction direction = Windows95Direction.topLeft,
  }) async {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Windows95LaunchOverlay(direction: direction),
    );

    await Future.delayed(const Duration(milliseconds: 200));
    Navigator.of(context).pop();

    onAction();
  }
}
