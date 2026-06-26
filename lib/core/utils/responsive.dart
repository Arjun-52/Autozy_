import 'dart:math' as math;
import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  Orientation get orientation => MediaQuery.of(this).orientation;

  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  /// Returns a responsive width based on design width of 375
  double w(double width) => (screenWidth / _designWidth) * width;

  /// Returns a responsive height based on design height of 812
  double h(double height) => (screenHeight / _designHeight) * height;

  /// Returns a responsive font size with clamped scale factor to avoid oversized text on tablets
  double sp(double fontSize) {
    final scale = screenWidth / _designWidth;
    final clampedScale = math.max(0.85, math.min(scale, 1.25));
    return fontSize * clampedScale;
  }
}
