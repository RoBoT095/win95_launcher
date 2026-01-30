import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter95/flutter95.dart';
import 'package:intl/intl.dart';

import 'package:win95_launcher/providers/date_time_provider.dart';
import 'package:win95_launcher/providers/settings_provider.dart';

import 'package:win95_launcher/models/app_alignment.dart';

import 'package:win95_launcher/screens/settings/date_time.dart';
import 'package:win95_launcher/screens/settings/app_settings.dart';
import 'package:win95_launcher/screens/app_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _channel = MethodChannel('launcher_settings');
  String _time = '';
  String _date = '';
  Timer? _timer;
  List<String> settingsList = ['setDefault', 'dateTime', 'appSettings'];
  Offset _panStart = Offset.zero;

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

  void openCameraApp() {
    const intent = AndroidIntent(
      action: 'android.media.action.STILL_IMAGE_CAMERA',
    );
    intent.launch();
  }

  void openPhoneApp() {
    const intent = AndroidIntent(action: 'android.intent.action.DIAL');
    intent.launch();
  }

  void openClockApp() {
    const intent = AndroidIntent(action: 'android.intent.action.SHOW_ALARMS');
    intent.launch();
  }

  void openCalendarApp() {
    const intent = AndroidIntent(
      action: 'android.intent.action.VIEW',
      data: 'content://com.android.calendar/time/',
    );
    intent.launch();
  }

  void openCalculatorApp() {
    // TODO
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
                    MaterialPageRoute(builder: (context) => DateTimeSettings()),
                  );
                }
                if (value == settingsList[2]) {
                  // App settings
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppSettings()),
                  );
                }
              },
            ),
          ),
          Item95(label: ' Clock ', onTap: (context) => openClockApp()),
          Item95(label: ' Calendar ', onTap: (context) => openCalendarApp()),
          Item95(label: ' Calculator', onTap: (context) => openCalculatorApp()),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GestureDetector(
          onDoubleTap: () {
            //
          },
          onPanStart: (details) {
            // Capture starting position
            _panStart = details.globalPosition;
          },
          onPanEnd: (details) {
            // Calculate total swipe distance when finger lifts
            final dx = details.globalPosition.dx - _panStart.dx;
            final dy = details.globalPosition.dy - _panStart.dy;

            // Determine if swipe is primarily horizontal or vertical
            final isHorizontal = dx.abs() > dy.abs();

            // Set a threshold for minimum swipe distance
            const threshold = 50.0;

            if (isHorizontal && dx.abs() > threshold) {
              if (dx > 0) {
                // Swipe Right
                openPhoneApp();
              } else {
                // Swipe Left
                openCameraApp();
              }
            } else if (!isHorizontal && dy.abs() > threshold) {
              if (dy < 0) {
                // Swipe Up
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AppList(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeOutCubic;
                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                );
              }
            }
          },

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
                        textAlign: watchSettings.homeAppAlignment.toTextAlign(),
                      ),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
