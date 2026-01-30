import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';

Widget headerText(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
    child: Container(
      height: 33,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Flutter95.headerDark, Flutter95.headerLight],
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(text, style: Flutter95.headerTextStyle),
          const Spacer(),
        ],
      ),
    ),
  );
}
