import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold95(
      title: 'About',
      onClosePressed: (val) => Navigator.pop(context),
      body: Elevation95(child: Container()),
    );
  }
}
