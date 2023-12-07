import 'package:flutter/material.dart';

class SimpleGradientDecoration extends BoxDecoration {
  const SimpleGradientDecoration({
    required Gradient gradient,
    BorderRadius radius = BorderRadius.zero,
  }) : super(
            gradient: gradient,
            borderRadius: radius);
}
