import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter95/flutter95.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:pixelarticons/pixel.dart';

import 'package:win95_launcher/providers/date_time_provider.dart';

import 'package:win95_launcher/models/time_format.dart';
import 'package:win95_launcher/models/date_format.dart';

class CustomHomeHeader extends WindowHeader95 {
  const CustomHomeHeader({super.key});

  @override
  State<CustomHomeHeader> createState() => _CustomHomeHeader();
}

class _CustomHomeHeader extends State<CustomHomeHeader> {
  String _time = '';
  String _date = '';
  IconData _batteryIcon = Pixel.batteryfull;
  Timer? _timer;

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

    return WindowHeader95(
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
    );
  }
}
