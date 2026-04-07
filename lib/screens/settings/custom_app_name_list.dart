import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';
import 'package:provider/provider.dart';
import 'package:pixelarticons/pixelarticons.dart';

import 'package:win95_launcher/providers/app_list_provider.dart';
import 'package:win95_launcher/providers/settings_provider.dart';

class CustomAppNameListPage extends StatelessWidget {
  const CustomAppNameListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final readALProv = context.read<AppListProvider>();
    final watchALProv = context.watch<AppListProvider>();

    final renamedAppList = readALProv.customAppNames.keys.toList();

    return Scaffold95(
      title: 'Custom App Name List',
      onClosePressed: (val) => Navigator.pop(context),
      body: Elevation95(
        child: Material(
          color: Colors.transparent,
          child: renamedAppList.isEmpty
              ? Center(child: Text('No apps have been renamed'))
              : ListView.builder(
                  itemCount: renamedAppList.length,
                  itemBuilder: (context, index) {
                    final pkg = renamedAppList[index];
                    final origName =
                        readALProv.appList
                            .firstWhere((e) => e.packageName == pkg)
                            .appName ??
                        pkg;

                    final img = watchALProv.imageForPackage(
                      pkg,
                      pixelate: context
                          .read<SettingsProvider>()
                          .pixelateAppIcons,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    );
                    return ListTile(
                      leading:
                          img ??
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(Pixel.alert),
                          ),
                      title: Text(readALProv.customAppNames[pkg] ?? pkg),
                      subtitle: Text('Old: $origName'),
                      trailing: IconButton(
                        onPressed: () => readALProv.removeCustomAppName(pkg),
                        icon: Icon(Pixel.close, size: 20),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
