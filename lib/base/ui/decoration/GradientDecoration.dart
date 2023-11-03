import 'package:flutter/material.dart';

class GradientDecoration extends BoxDecoration {
  const GradientDecoration({
    required Gradient gradient,
    BorderRadius radius = BorderRadius.zero,
  }) : super(
            gradient: gradient,
            borderRadius: radius);
}
