import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_install_events/app_install_events.dart';

import 'package:win95_launcher/constants/storage_keys/settings_pref_keys.dart';

import 'package:win95_launcher/providers/date_time_provider.dart';
import 'package:win95_launcher/providers/settings_provider.dart';
import 'package:win95_launcher/providers/app_list_provider.dart';

import 'package:win95_launcher/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  late AppIUEvents _appIUEvents;

  @override
  void initState() {
    loadApp();
    checkAppIUEvents();
    super.initState();
  }

  void loadApp() async {
    await App.init();
    SystemChrome.setPreferredOrientations(
      App.localStorage.getBool(allowRotation) ?? true
          ? []
          : [DeviceOrientation.portraitUp],
    );
    setState(() => _isLoading = false);
  }

  void checkAppIUEvents() {
    _appIUEvents = AppIUEvents();

    _appIUEvents.appEvents.listen((event) {
      debugPrint('${event.packageName} was ${event.type.name}');
      if (event.type == IUEventType.installed) {
        Provider.of<AppListProvider>(context, listen: false).loadApps();
      }
      if (event.type == IUEventType.uninstalled) {
        Provider.of<AppListProvider>(
          context,
          listen: false,
        ).removeUninstalledFromHome(event.packageName);
        Provider.of<AppListProvider>(context, listen: false).loadApps();
      }
    });
  }

  @override
  void dispose() {
    _appIUEvents.dispose();
    super.dispose();
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
