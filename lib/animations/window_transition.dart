import 'package:flutter/material.dart';

// Direction enum for the expanding rectangle animation
enum Windows95Direction {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
  left,
  center,
  right,
}

// Windows 95 Style Page Route Transition
class Windows95PageRoute extends PageRouteBuilder {
  final Widget page;
  final Windows95Direction direction;

  Windows95PageRoute({
    required this.page,
    this.direction = Windows95Direction.topLeft,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: const Duration(milliseconds: 300),
         reverseTransitionDuration: const Duration(milliseconds: 250),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return Windows95Transition(
             animation: animation,
             direction: direction,
             child: child,
           );
         },
       );
}

// The actual Windows 95 transition widget
class Windows95Transition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  final Windows95Direction direction;

  const Windows95Transition({
    Key? key,
    required this.animation,
    required this.child,
    this.direction = Windows95Direction.topLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          children: [
            // Fade in the actual page content
            FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
                ),
              ),
              child: child,
            ),
            // Windows 95 expanding rectangle border
            if (animation.value < 1.0)
              CustomPaint(
                painter: Windows95RectanglePainter(
                  progress: animation.value,
                  direction: direction,
                ),
                child: Container(),
              ),
          ],
        );
      },
      child: child,
    );
  }
}

// Custom painter for the expanding rectangle effect
class Windows95RectanglePainter extends CustomPainter {
  final double progress;
  final Windows95Direction direction;

  Windows95RectanglePainter({
    required this.progress,
    this.direction = Windows95Direction.topLeft,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Calculate the expanding rectangle dimensions
    final width = size.width * progress;
    final height = size.height * progress;

    Rect rect;

    // Draw the rectangle expanding from different directions
    switch (direction) {
      case Windows95Direction.topLeft:
        rect = Rect.fromLTWH(0, 0, width, height);
        break;
      case Windows95Direction.topCenter:
        final centerX = (size.width - width) / 2;
        rect = Rect.fromLTWH(centerX, 0, width, height);
        break;
      case Windows95Direction.topRight:
        rect = Rect.fromLTWH(size.width - width, 0, width, height);
        break;
      case Windows95Direction.bottomLeft:
        rect = Rect.fromLTWH(0, size.height - height, width, height);
        break;
      case Windows95Direction.bottomCenter:
        final centerX = (size.width - width) / 2;
        rect = Rect.fromLTWH(centerX, size.height - height, width, height);
        break;
      case Windows95Direction.bottomRight:
        rect = Rect.fromLTWH(
          size.width - width,
          size.height - height,
          width,
          height,
        );
        break;
      case Windows95Direction.left:
        final centerY = (size.height - height) / 2;
        rect = Rect.fromLTWH(0, centerY, width, height);
        break;
      case Windows95Direction.center:
        final centerX = (size.width - width) / 2;
        final centerY = (size.height - height) / 2;
        rect = Rect.fromLTWH(centerX, centerY, width, height);
        break;
      case Windows95Direction.right:
        final centerY = (size.height - height) / 2;
        rect = Rect.fromLTWH(size.width - width, centerY, width, height);
        break;
    }

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(Windows95RectanglePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.direction != direction;
  }
}

class Windows95LaunchOverlay extends StatefulWidget {
  const Windows95LaunchOverlay({
    super.key,
    this.direction = Windows95Direction.topLeft,
  });

  final Windows95Direction direction;

  @override
  State<Windows95LaunchOverlay> createState() => _Windows95LaunchOverlayState();
}

class _Windows95LaunchOverlayState extends State<Windows95LaunchOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: Windows95RectanglePainter(
            progress: _controller.value,
            direction: widget.direction,
          ),
        );
      },
    );
  }
}
