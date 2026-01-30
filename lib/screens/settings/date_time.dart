import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter95/flutter95.dart';

import 'package:win95_launcher/providers/date_time_provider.dart';

import 'package:win95_launcher/components/header_text_widget.dart';

class DateTimeSettings extends StatefulWidget {
  const DateTimeSettings({super.key});

  @override
  State<DateTimeSettings> createState() => _DateTimeSettingsState();
}

class _DateTimeSettingsState extends State<DateTimeSettings> {
  @override
  Widget build(BuildContext context) {
    final readDTProvider = context.read<DateTimeProvider>();
    final watchDTProvider = context.watch<DateTimeProvider>();
    return Scaffold95(
      title: 'Date/Time Settings',
      onClosePressed: (val) => Navigator.pop(context),
      body: Elevation95(
        child: Material(
          color: Colors.transparent,
          child: ListView(
            shrinkWrap: true,
            children: [
              Divider95(),
              headerText('Appearance'),
              Divider95(),
              ListTile(
                title: Text('Show time'),
                trailing: Checkbox95(
                  value: watchDTProvider.showTime,
                  onChanged: (value) => readDTProvider.setShowTime(value),
                ),
              ),
              ListTile(
                title: Text('Show date'),
                trailing: Checkbox95(
                  value: watchDTProvider.showDate,
                  onChanged: (value) => readDTProvider.setShowDate(value),
                ),
              ),
              Divider95(),
              headerText('Format'),
              Divider95(),
              ListTile(title: Text('Time Format')),
              ListTile(title: Text('Date Format')),
            ],
          ),
        ),
      ),
    );
  }
}
