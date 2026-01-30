import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter95/flutter95.dart';
import 'package:pixelarticons/pixel.dart';

import 'package:win95_launcher/providers/date_time_provider.dart';

import 'package:win95_launcher/models/time_format.dart';
import 'package:win95_launcher/models/date_format.dart';

import 'package:win95_launcher/components/header_text_widget.dart';
import 'package:win95_launcher/components/tile_item_95.dart';

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
              headerText('Appearance'),
              Divider95(),
              ListTile(
                leading: Icon(Pixel.clock),
                title: Text('Show time'),
                trailing: Checkbox95(
                  value: watchDTProvider.showTime,
                  onChanged: (value) => readDTProvider.setShowTime(value),
                ),
              ),
              ListTile(
                leading: Icon(Pixel.calendarmonth),
                title: Text('Show date'),
                trailing: Checkbox95(
                  value: watchDTProvider.showDate,
                  onChanged: (value) => readDTProvider.setShowDate(value),
                ),
              ),
              Divider95(),
              headerText('Format'),
              Divider95(),
              ListTile(
                leading: Icon(Pixel.sunalt),
                title: Text('Time Format'),
                trailing: tileItem95(
                  width: 200,
                  label: watchDTProvider.timeFormat.example,
                  menu: Menu95(
                    items: [
                      MenuItem95(
                        value: TimeFormatType.time12Hour,
                        label: '2:30 PM',
                      ),
                      MenuItem95(
                        value: TimeFormatType.time24Hour,
                        label: '14:30',
                      ),
                      MenuItem95(
                        value: TimeFormatType.time12HourWithSeconds,
                        label: '2:30:45 PM',
                      ),
                      MenuItem95(
                        value: TimeFormatType.time24HourWithSeconds,
                        label: '14:30:45',
                      ),
                      MenuItem95(value: TimeFormatType.hour12, label: '2 PM'),
                      MenuItem95(value: TimeFormatType.hour24, label: '14'),
                      MenuItem95(
                        value: TimeFormatType.time12HourPadded,
                        label: '02:30 PM',
                      ),
                      MenuItem95(
                        value: TimeFormatType.time24HourPadded,
                        label: '14:30',
                      ),
                      MenuItem95(
                        value: TimeFormatType.time12HourPaddedWithSeconds,
                        label: '02:30:45 PM',
                      ),
                      MenuItem95(
                        value: TimeFormatType.time24HourPaddedWithSeconds,
                        label: '14:30:45',
                      ),
                    ],
                    onItemSelected: (value) {
                      if (value != null) {
                        readDTProvider.setTimeFormat(value as TimeFormatType);
                      }
                    },
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Pixel.calendarcheck),
                title: Text('Date Format'),
                trailing: tileItem95(
                  width: 200,
                  label: watchDTProvider.dateFormat.example,
                  menu: Menu95(
                    items: [
                      MenuItem95(
                        value: DateFormatType.mediumDate,
                        label: 'Aug 24, 1995',
                      ),
                      MenuItem95(
                        value: DateFormatType.longDate,
                        label: 'August 24, 1995',
                      ),
                      MenuItem95(
                        value: DateFormatType.shortDate,
                        label: '8/24/1995',
                      ),
                      MenuItem95(
                        value: DateFormatType.isoDate,
                        label: '1995-08-24',
                      ),
                      MenuItem95(
                        value: DateFormatType.fullDate,
                        label: 'Thursday, August 24, 1995',
                      ),
                      MenuItem95(
                        value: DateFormatType.abbrevDate,
                        label: 'Thu, Aug 24, 1995',
                      ),
                      MenuItem95(
                        value: DateFormatType.monthYear,
                        label: 'August 1995',
                      ),
                      MenuItem95(
                        value: DateFormatType.abbrevMonthYear,
                        label: 'Aug 1995',
                      ),
                      MenuItem95(
                        value: DateFormatType.numericMonthYear,
                        label: '08/1995',
                      ),
                      MenuItem95(
                        value: DateFormatType.monthDay,
                        label: 'August 24',
                      ),
                      MenuItem95(
                        value: DateFormatType.abbrevMonthDay,
                        label: 'Aug 24',
                      ),
                      MenuItem95(
                        value: DateFormatType.numericMonthDay,
                        label: '08/24',
                      ),
                      MenuItem95(
                        value: DateFormatType.weekday,
                        label: 'Thursday',
                      ),
                      MenuItem95(
                        value: DateFormatType.abbrevWeekday,
                        label: 'Thu',
                      ),
                      MenuItem95(
                        value: DateFormatType.weekdayMonthDay,
                        label: 'Thursday, Aug 24',
                      ),
                      MenuItem95(value: DateFormatType.year, label: '1995'),
                      MenuItem95(value: DateFormatType.shortYear, label: '95'),
                      MenuItem95(
                        value: DateFormatType.dashedDate,
                        label: '24-Aug-1995',
                      ),
                      MenuItem95(
                        value: DateFormatType.dottedDate,
                        label: '24.08.1995',
                      ),
                      MenuItem95(
                        value: DateFormatType.dateWithOrdinal,
                        label: 'Aug 24th, 1995',
                      ),
                    ],
                    onItemSelected: (value) {
                      if (value != null) {
                        readDTProvider.setDateFormat(value as DateFormatType);
                      }
                    },
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
