import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter95/flutter95.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:pixelarticons/pixel.dart';

import 'package:win95_launcher/providers/settings_provider.dart';
import 'package:win95_launcher/providers/date_time_provider.dart';

import 'package:win95_launcher/models/time_format.dart';
import 'package:win95_launcher/models/date_format.dart';
import 'package:win95_launcher/animations/window_transition.dart';

import 'package:win95_launcher/screens/settings/date_time.dart';
import 'package:win95_launcher/screens/settings/app_settings.dart';
import 'package:win95_launcher/screens/settings/info.dart';

class CustomHomeHeader extends StatefulWidget {
  const CustomHomeHeader({super.key});

  @override
  State<CustomHomeHeader> createState() => _CustomHomeHeader();
}

class _CustomHomeHeader extends State<CustomHomeHeader> {
  String _time = '';
  String _date = '';
  IconData _batteryIcon = Pixel.batteryfull;
  Timer? _timer;

  List<String> settingsList = [
    'setDefault',
    'dateTime',
    'appSettings',
    'infoPage',
  ];

  @override
  void initState() {
    _getHeaderData();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _getHeaderData(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getHeaderData() async {
    final readDTProvider = context.read<DateTimeProvider>();
    final batteryState = await Battery().batteryState;
    final batteryCharge = await Battery().batteryLevel;

    final DateTime now = DateTime.now();
    final timeModel = TimeFormatModel(now);
    final dateModel = DateFormatModel(now);
    final IconData icon;

    final String formattedTime = timeModel.formatByType(
      readDTProvider.timeFormat,
    );
    final String formattedDate = dateModel.formatByType(
      readDTProvider.dateFormat,
    );

    if (batteryState == BatteryState.charging) {
      icon = Pixel.batterycharging;
    } else if (batteryCharge >= 75) {
      icon = Pixel.batteryfull;
    } else if (batteryCharge >= 45) {
      icon = Pixel.battery2;
    } else if (batteryCharge >= 15) {
      icon = Pixel.battery1;
    } else {
      icon = Pixel.battery;
    }

    setState(() {
      _time = formattedTime;
      _date = formattedDate;
      _batteryIcon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final readDTProvider = context.read<DateTimeProvider>();
    final readSettings = context.read<SettingsProvider>();

    return Container(
      color: Color(0xFFd2d2d2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WindowHeader95(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),

                    if (readDTProvider.showTime)
                      Text(_time, style: Flutter95.headerTextStyle),
                    if (readDTProvider.showTime && readDTProvider.showDate)
                      Text(' | ', style: Flutter95.headerTextStyle),
                    if (readDTProvider.showDate)
                      Flexible(
                        child: Text(
                          _date,
                          style: Flutter95.headerTextStyle.copyWith(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                    // Spacer(),
                  ],
                ),
                if (readDTProvider.showBattery)
                  Positioned(
                    right: 8,
                    child: Icon(_batteryIcon, color: Flutter95.white),
                  ),
              ],
            ),
          ),
          Toolbar95(
            actions: [
              Item95(
                label: 'Settings ',
                menu: Menu95(
                  items: [
                    MenuItem95(
                      value: settingsList[0],
                      label: 'Set Default Launcher',
                    ),
                    MenuItem95(
                      value: settingsList[1],
                      label: 'Format Clock/Date',
                    ),
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
                      Navigator.push(
                        context,
                        Windows95PageRoute(page: InfoPage()),
                      );
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
        ],
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
    if (mounted) Navigator.of(context).pop();

    onAction();
  }
}
