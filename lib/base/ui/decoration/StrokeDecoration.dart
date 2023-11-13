import 'package:flutter/material.dart';

import '../../config/ColorConfig.dart';

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

  /// fffff
  StrokeDecoration.whiteRadius4()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(4));

  StrokeDecoration.whiteRadius8()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(8));

  StrokeDecoration.whiteRadius10()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(10));

  StrokeDecoration.whiteRadius16()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(16));

  StrokeDecoration.whiteRadius24()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(24));

  StrokeDecoration.whiteRadius32()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(32));

  /// f2f2f2
  StrokeDecoration.whiteF2f2f2Radius4()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(4));

  StrokeDecoration.whiteF2f2f2Radius48()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(8));

  StrokeDecoration.whiteF2f2f2Radius410()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(10));

  StrokeDecoration.whiteF2f2f2Radius416()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(16));

  StrokeDecoration.whiteF2f2f2Radius424()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(24));

  StrokeDecoration.whiteF2f2f2Radius432()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(32));

  /// 000000
  StrokeDecoration.blackRadius4()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(4));

  StrokeDecoration.blackRadius8()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(8));

  StrokeDecoration.blackRadius10()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(10));

  StrokeDecoration.blackRadius16()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(16));

  StrokeDecoration.blackRadius24()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(24));

  StrokeDecoration.blackRadius32()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(32));
}
