import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:win95_launcher/providers/date_time_provider.dart';
import 'package:win95_launcher/providers/settings_provider.dart';
import 'package:win95_launcher/providers/app_list_provider.dart';

import 'package:win95_launcher/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DateTimeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AppListProvider()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  static late SharedPreferences localStorage;

  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isLoading = true;

  @override
  void initState() {
    loadApp();
    super.initState();
  }

  void loadApp() async {
    await App.init();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'W95FA',
      ),
      home: _isLoading
          ? Center(child: CircularProgressIndicator())
          : const HomeScreen(),
    );
  }
}
