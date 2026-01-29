import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';

class DateTimeSettings extends StatefulWidget {
  const DateTimeSettings({super.key});

  @override
  State<DateTimeSettings> createState() => _DateTimeSettingsState();
}

class _DateTimeSettingsState extends State<DateTimeSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold95(
      title: 'Date/Time Settings',
      onClosePressed: (val) => Navigator.pop(context),
      body: Container(),
    );
  }
}
