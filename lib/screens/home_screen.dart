import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter95/flutter95.dart';
import 'package:intl/intl.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

import 'package:win95_launcher/providers/date_time_provider.dart';
import 'package:win95_launcher/providers/settings_provider.dart';

import 'package:win95_launcher/models/app_alignment.dart';
import 'package:win95_launcher/animations/window_transition.dart';

import 'package:win95_launcher/screens/settings/date_time.dart';
import 'package:win95_launcher/screens/settings/app_settings.dart';
import 'package:win95_launcher/screens/settings/info.dart';
import 'package:win95_launcher/screens/app_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _channel = MethodChannel('custom_functions');
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
    final DateTime now = DateTime.now();
    final String formattedTime = DateFormat.jms().format(now).toString();
    final String formattedDate = DateFormat.yMMMMd(
      Platform.localeName,
    ).format(now).toString();

    setState(() {
      _time = formattedTime;
      _date = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final readDTProvider = context.read<DateTimeProvider>();
    final watchSettings = context.watch<SettingsProvider>();

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
              onItemSelected: (value) async {
                if (value == settingsList[0]) {
                  // Set default launcher
                  await _channel.invokeMethod('openLauncherChooser');
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
            onTap: (context) => openApp(
              direction: Windows95Direction.topLeft,
              launchApp: () {
                const intent = AndroidIntent(
                  action: 'android.intent.action.SHOW_ALARMS',
                );
                intent.launch();
              },
            ),
          ),
          Item95(
            label: ' Calendar ',
            onTap: (context) => openApp(
              direction: Windows95Direction.topLeft,
              launchApp: () {
                const intent = AndroidIntent(
                  action: 'android.intent.action.VIEW',
                  data: 'content://com.android.calendar/time/',
                );
                intent.launch();
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SwipeDetector(
          onSwipeRight: (offset) {
            openRightApp();
          },
          onSwipeLeft: (offset) {
            openLeftApp();
          },
          onSwipeUp: (offset) {
            Navigator.push(
              context,
              Windows95PageRoute(
                page: AppList(),
                direction: Windows95Direction.bottomCenter,
              ),
            );
          },
          onSwipeDown: (offset) {
            _channel.invokeMethod('openNotificationPanel');
          },
          child: GestureDetector(
            onDoubleTap: openDoubleTapApp,
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
                      return ListTile(
                        title: Text(
                          'Open App ${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: watchSettings.textSize,
                          ),
                          textAlign: watchSettings.homeAppAlignment
                              .toTextAlign(),
                        ),
                        onTap: () {
                          // TODO: launch selected app
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
    );
  }

  void openLeftApp() {
    openApp(
      direction: Windows95Direction.right,
      launchApp: () {
        // Default Camera App
        const intent = AndroidIntent(
          action: 'android.media.action.STILL_IMAGE_CAMERA',
        );
        intent.launch();
      },
    );
  }

  void openRightApp() async {
    openApp(
      direction: Windows95Direction.left,
      launchApp: () {
        // Default Phone App
        const intent = AndroidIntent(action: 'android.intent.action.DIAL');
        intent.launch();
      },
    );
  }

  void openDoubleTapApp() async {
    openApp(direction: Windows95Direction.center, launchApp: () {});
  }

  void openApp({
    required Function() launchApp,
    Windows95Direction direction = Windows95Direction.topLeft,
  }) async {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Windows95LaunchOverlay(direction: direction),
    );

    await Future.delayed(const Duration(milliseconds: 200));
    Navigator.of(context).pop();

    launchApp();
  }
}
