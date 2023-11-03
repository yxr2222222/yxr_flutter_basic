import 'package:flutter/material.dart';

class ShapeDecoration extends BoxDecoration {
  const ShapeDecoration(
      {required Color color, BorderRadius radius = BorderRadius.zero})
      : super(color: color, borderRadius: radius);
}
