import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pixelarticons/pixelarticons.dart';

import 'package:win95_launcher/constants/constants.dart' as c;

import 'package:win95_launcher/utils/handlers/open_url.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold95(
      title: 'About',
      onClosePressed: (val) => Navigator.pop(context),
      body: Elevation95(
        child: Material(
          color: Colors.transparent,
          child: ListView(
            children: [
              // SizedBox(height: 250, child: Icon(Pixel.downasaur, size: 200)),
              Center(
                child: Elevation95(
                  child: ColoredBox(
                    color: Colors.white,
                    child: SvgPicture.asset(
                      'assets/images/clippy.svg',
                      height: 250,
                    ),
                  ),
                ),
              ),

              menuTile(
                icon: Pixel.infobox,
                title: 'Version',
                subtitle: c.appVersion,
              ),
              menuTile(
                icon: Pixel.user,
                title: 'Author:',
                subtitle: 'RoBoT_095',
                trailing: Icon(Pixel.externallink, size: 35),
                onTap: () => urlHandler(context, 'https://github.com/RoBoT095'),
              ),
              menuTile(
                icon: Pixel.at,
                title: 'Contact At',
                subtitle: 'robot095@robot095.com',
                trailing: Icon(Pixel.externallink, size: 35),
                onTap: () =>
                    urlHandler(context, 'robot095@robot095.com', email: true),
              ),
              menuTile(
                icon: Pixel.scripttext,
                title: 'License',
                subtitle: 'This app is under GPL v2.0',
                trailing: Icon(Pixel.externallink, size: 35),
                onTap: () => urlHandler(
                  context,
                  'https://github.com/RoBoT095/win95_launcher/blob/master/LICENSE',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget menuTile({
  String title = '',
  String subtitle = '',
  IconData icon = Pixel.pixelarticons,
  Widget? trailing,
  Function()? onTap,
}) {
  return ListTile(
    leading: Icon(icon, size: 45),
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    ),
    subtitle: Text(subtitle, style: Flutter95.textStyle.copyWith(fontSize: 20)),
    trailing: trailing,
    onTap: onTap,
  );
}
