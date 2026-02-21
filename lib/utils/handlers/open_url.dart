import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:win95_launcher/components/basic_popup.dart';

Future<void> urlHandler(
  BuildContext context,
  String url, {
  bool email = false,
}) async {
  Uri uri;

  if (email) {
    uri = Uri(scheme: 'mailto', path: url);
  } else {
    uri = Uri.parse(url);
  }

  if (context.mounted) {
    final response = await showBasicPopup(
      context,
      'Open Link?',
      'Are you sure you want to open:\n"$url"?',
    );
    if (response) {
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
    }
  }
}
