import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DateTimeProvider with ChangeNotifier {
  DateTimeProvider() {
    loadSettings();
  }

  void loadSettings() {}
}
