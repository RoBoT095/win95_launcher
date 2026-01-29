import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter95/flutter95.dart';
import 'package:win95_launcher/screens/app_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _time = '';
  String _date = '';
  Timer? _timer;

  @override
  void initState() {
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
      'en_US',
    ).format(now).toString();

    setState(() {
      _time = formattedTime;
      _date = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold95(
      title: '$_time | $_date',
      toolbar: Toolbar95(
        actions: [
          Item95(
            label: 'Settings ',
            menu: Menu95(
              items: [
                MenuItem95(value: 'setDefault', label: 'Set Default Launcher'),
                MenuItem95(value: 'timeFormat', label: 'Format Clock'),
                MenuItem95(value: 'dateFormat', label: 'Format Date'),
                MenuItem95(value: 'homeScreen', label: 'Home Screen'),
                MenuItem95(value: 'behavior', label: 'Behavior'),
                MenuItem95(value: 'alignment', label: 'Alignment'),
                MenuItem95(value: 'gestures', label: 'Gestures'),
                MenuItem95(value: 'backup', label: 'Settings Backup'),
              ],
              onItemSelected: (context) {},
            ),
          ),
          Item95(label: ' Clock ', onTap: (context) {}),
          Item95(label: ' Calendar ', onTap: (context) {}),
          Item95(label: ' Calculator', onTap: (context) {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GestureDetector(
          onDoubleTap: () {
            //
          },
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              // Swipe Right
            }
            if (details.delta.dx < 0) {
              // Swipe Left
            }
            if (details.delta.dy < 0) {
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
          },
          child: Elevation95(
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5, // Set limit to 10
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        'Open App ${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
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
