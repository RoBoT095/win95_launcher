import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';

Future<bool> showBasicPopup(
  BuildContext context,
  String title,
  String content,
) async {
  return await showDialog(
        context: context,
        builder: (context) => Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.widthOf(context)) / 1.1,
            child: IntrinsicHeight(
              child: Scaffold95(
                title: title,
                body: Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(content, style: Flutter95.textStyle),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Button95(
                            onTap: () => Navigator.of(context).pop(false),
                            child: Text('No'),
                          ),
                          Button95(
                            onTap: () => Navigator.of(context).pop(true),
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ) ??
      false;
}

// AlertDialog(
//           title: Text(title),
//           content: Text(content),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: Text(
//                 'No',
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.secondary,
//                 ),
//               ),
//             ),
//             TextButton(
//               style: TextButton.styleFrom(
//                 backgroundColor: Theme.of(context).colorScheme.secondary,
//                 foregroundColor: Theme.of(context).colorScheme.onSecondary,
//               ),
//               onPressed: () => Navigator.of(context).pop(true),
//               child: const Text('Yes'),
//             ),
//           ],
//         ),
