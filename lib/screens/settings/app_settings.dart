import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter95/flutter95.dart';

import 'package:win95_launcher/providers/settings_provider.dart';

import 'package:win95_launcher/models/app_alignment.dart';

import 'package:win95_launcher/components/header_text_widget.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    final readSettings = context.read<SettingsProvider>();
    final watchSettings = context.watch<SettingsProvider>();

    return Scaffold95(
      title: 'Settings',
      onClosePressed: (val) {
        Navigator.pop(context);
      },
      body: Elevation95(
        child: Material(
          color: Colors.transparent,
          child: ListView(
            shrinkWrap: true,
            children: [
              headerText('Appearance'),
              Divider95(),
              ListTile(
                title: Text('Show status bar'),
                trailing: Checkbox95(
                  value: watchSettings.showStatusBar,
                  onChanged: (value) =>
                      readSettings.setStatusBarVisibility(value),
                ),
              ),
              ListTile(title: Text('Text Size')),
              ListTile(title: Text('Number of shortcuts')),
              Divider95(),
              headerText('Behavior'),
              Divider95(),
              ListTile(
                title: Text('Auto show keyboard'),
                trailing: Checkbox95(
                  value: watchSettings.autoShowKeyboard,
                  onChanged: (value) => readSettings.setAutoShowKeyboard(value),
                ),
              ),
              Divider95(),
              headerText('Alignment'),
              Divider95(),
              ListTile(
                title: Text('Apps home screen'),
                trailing: Elevation95(
                  child: SizedBox(
                    width: 75,
                    child: Item95(
                      label: readSettings.homeAppAlignment.toString(),
                      menu: Menu95(
                        items: [
                          MenuItem95(
                            value: AppAlignment.left,
                            label: AppAlignment.left.toString(),
                          ),
                          MenuItem95(
                            value: AppAlignment.center,
                            label: AppAlignment.center.toString(),
                          ),
                          MenuItem95(
                            value: AppAlignment.right,
                            label: AppAlignment.right.toString(),
                          ),
                        ],
                        onItemSelected: (value) {
                          readSettings.setHomeAppAlignment(value);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text('App home screen bottom'),
                trailing: Checkbox95(
                  value: watchSettings.homeAppBottom,
                  onChanged: (value) => readSettings.setHomeAppBottom(value),
                ),
              ),
              ListTile(
                title: Text('Apps in drawer'),
                trailing: Elevation95(
                  child: SizedBox(
                    width: 75,
                    child: Item95(
                      label: readSettings.appListAlignment.toString(),
                      menu: Menu95(
                        items: [
                          MenuItem95(
                            value: AppAlignment.left,
                            label: AppAlignment.left.toString(),
                          ),
                          MenuItem95(
                            value: AppAlignment.center,
                            label: AppAlignment.center.toString(),
                          ),
                          MenuItem95(
                            value: AppAlignment.right,
                            label: AppAlignment.right.toString(),
                          ),
                        ],
                        onItemSelected: (value) {
                          readSettings.setAppListAlignment(value);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Divider95(),
              headerText('Gestures'),
              Divider95(),
              ListTile(title: Text('Swipe left')),
              ListTile(title: Text('Swipe right')),
              ListTile(title: Text('Swipe Up')),
              ListTile(title: Text('Double Tap')),
              Divider95(),
            ],
          ),
        ),
      ),
    );
  }
}
