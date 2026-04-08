import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter95/flutter95.dart';

import 'package:win95_launcher/providers/settings_provider.dart';
import 'package:win95_launcher/providers/date_time_provider.dart';

import 'package:win95_launcher/models/time_format.dart';
import 'package:win95_launcher/models/gesture_action.dart';
import 'package:win95_launcher/animations/window_transition.dart';

class CustomHomeBottomBar extends StatefulWidget {
  const CustomHomeBottomBar({super.key});

  @override
  State<CustomHomeBottomBar> createState() => _CustomHomeBottomBar();
}

class _CustomHomeBottomBar extends State<CustomHomeBottomBar> {
  String _time = '';
  Timer? _timer;

  @override
  void initState() {
    _getTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _getTime(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getTime() async {
    final readDTProvider = context.read<DateTimeProvider>();

    final DateTime now = DateTime.now();
    final timeModel = TimeFormatModel(now);

    final String formattedTime = timeModel.formatByType(
      readDTProvider.timeFormat,
    );

    setState(() => _time = formattedTime);
  }

  @override
  Widget build(BuildContext context) {
    final readSettings = context.read<SettingsProvider>();
    return ColoredBox(
      color: Color(0xFFd2d2d2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Elevation95(
            child: SizedBox(
              height: 35,
              child: Row(
                children: [
                  Button95(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 4.0,
                    ),
                    onTap: () => runTransition(
                      direction: Windows95Direction.bottomLeft,
                      onAction: () => readSettings.executeGestureAction(
                        context,
                        GestureAction(type: GestureActionType.showAppList),
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/Windows95_start_logo.png',
                          height: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Start',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontFamily: 'W95FA',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),

                  Button95(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 4.0),
                    onTap: () => runTransition(
                      direction: Windows95Direction.bottomRight,
                      onAction: () => readSettings.executeGestureAction(
                        context,
                        GestureAction(type: GestureActionType.clock),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _time,
                        style: Flutter95.textStyle.copyWith(
                          fontFamily: 'W95FA',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
