import 'package:flutter/material.dart';
import 'package:flutter95/flutter95.dart';

class WindowWidget extends StatelessWidget {
  const WindowWidget({super.key, required this.child, this.scrollController});

  final Widget child;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Elevation95(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 33,
              child: Padding(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(
                          'assets/icons/programs.ico',
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text('Applications', style: Flutter95.headerTextStyle),
                      const Spacer(),
                      headerButton(icon: Icons.minimize, onTap: () {}),
                      headerButton(
                        icon: Icons.check_box_outline_blank,
                        onTap: () {},
                      ),
                      const SizedBox(width: 2),
                      headerButton(icon: Icons.close, onTap: () {}),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4.0),
              child: Elevation95(
                type: Elevation95Type.down,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  color: Colors.white,
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerButton({
    required IconData icon,
    required dynamic Function()? onTap,
  }) {
    return Button95(
      height: 24,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Icon(
        icon,
        size: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
