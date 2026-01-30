import 'package:flutter/material.dart';

/// Basic horizontal alignment options for
enum AppAlignment {
  left,
  center,
  right;

  /// Convert to Flutter Alignment
  Alignment toAlignment() {
    switch (this) {
      case AppAlignment.left:
        return Alignment.centerLeft;
      case AppAlignment.center:
        return Alignment.center;
      case AppAlignment.right:
        return Alignment.centerRight;
    }
  }

  /// Convert to Flutter TextAlign
  TextAlign toTextAlign() {
    switch (this) {
      case AppAlignment.left:
        return TextAlign.left;
      case AppAlignment.center:
        return TextAlign.center;
      case AppAlignment.right:
        return TextAlign.right;
    }
  }

  @override
  String toString() {
    switch (this) {
      case AppAlignment.left:
        return 'Left';
      case AppAlignment.center:
        return 'Center';
      case AppAlignment.right:
        return 'Right';
    }
  }
}

/// Bottom alignment options
extension type BottomAppAlignment(AppAlignment aA) {
  /// Convert to Flutter Alignment
  Alignment get toAlignment => switch (aA) {
    AppAlignment.left => Alignment.bottomLeft,
    AppAlignment.center => Alignment.center,
    AppAlignment.right => Alignment.bottomRight,
  };
}
