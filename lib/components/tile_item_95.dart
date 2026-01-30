import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';

Widget tileItem95({
  required String label,
  Function(BuildContext context)? onTap,
  Menu95? menu,
}) {
  return Elevation95(
    child: SizedBox(
      width: 75,
      child: Item95(label: label, onTap: onTap, menu: menu),
    ),
  );
}
