import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_device_apps/flutter_device_apps.dart';
import 'package:pixelarticons/pixelarticons.dart';

import 'package:win95_launcher/providers/settings_provider.dart';
import 'package:win95_launcher/providers/app_list_provider.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    this.appInfo,
    required this.title,
    this.showIcons,
    this.onTap,
    this.onLongPress,
    this.appAlignment,
  });

  final AppInfo? appInfo;
  final String title;
  final bool? showIcons;
  final Function()? onTap;
  final Function()? onLongPress;
  final Alignment? appAlignment;

  @override
  Widget build(BuildContext context) {
    final readAppListProv = context.read<AppListProvider>();
    final watchSettings = context.watch<SettingsProvider>();

    double iconSize = 40;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Align(
        alignment: appAlignment ?? Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (appInfo != null && showIcons == true)
              readAppListProv.imageForPackage(
                    appInfo!.packageName!,
                    pixelate: watchSettings.pixelateAppIcons,
                    pixelationLevel: watchSettings.pixelationLevel,
                    width: iconSize,
                    height: iconSize,
                  ) ??
                  SizedBox(width: iconSize, height: iconSize),
            if (appInfo == null && showIcons == true)
              SizedBox(
                width: iconSize,
                height: iconSize,
                child: Icon(Pixel.plus),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 10.0,
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: watchSettings.textSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
