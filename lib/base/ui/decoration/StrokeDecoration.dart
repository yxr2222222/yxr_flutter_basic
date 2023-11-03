import 'package:flutter/material.dart';

class StrokeDecoration extends BoxDecoration {
  StrokeDecoration({
    required Color borderColor,
    double strokeWidth = 0.5,
    BorderRadius radius = BorderRadius.zero,
    Color? color,
  }) : super(
            color: color,
            border: Border.all(width: strokeWidth, color: borderColor),
            borderRadius: radius);
}
