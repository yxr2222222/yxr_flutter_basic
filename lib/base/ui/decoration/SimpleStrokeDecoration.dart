import 'package:flutter/material.dart';

import '../../config/ColorConfig.dart';

class SimpleStrokeDecoration extends BoxDecoration {
  SimpleStrokeDecoration({
    required Color borderColor,
    double strokeWidth = 0.5,
    BorderRadius radius = BorderRadius.zero,
    Color? color,
  }) : super(
            color: color,
            border: Border.all(width: strokeWidth, color: borderColor),
            borderRadius: radius);

  /// fffff
  SimpleStrokeDecoration.whiteRadius4()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(4));

  SimpleStrokeDecoration.whiteRadius8()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(8));

  SimpleStrokeDecoration.whiteRadius10()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(10));

  SimpleStrokeDecoration.whiteRadius16()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(16));

  SimpleStrokeDecoration.whiteRadius24()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(24));

  SimpleStrokeDecoration.whiteRadius32()
      : super(
            border: Border.all(width: 0.5, color: Colors.white),
            borderRadius: BorderRadius.circular(32));

  /// f2f2f2
  SimpleStrokeDecoration.whiteF2f2f2Radius4()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(4));

  SimpleStrokeDecoration.whiteF2f2f2Radius48()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(8));

  SimpleStrokeDecoration.whiteF2f2f2Radius410()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(10));

  SimpleStrokeDecoration.whiteF2f2f2Radius416()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(16));

  SimpleStrokeDecoration.whiteF2f2f2Radius424()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(24));

  SimpleStrokeDecoration.whiteF2f2f2Radius432()
      : super(
            border: Border.all(width: 0.5, color: ColorConfig.white_f2f2f2),
            borderRadius: BorderRadius.circular(32));

  /// 000000
  SimpleStrokeDecoration.blackRadius4()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(4));

  SimpleStrokeDecoration.blackRadius8()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(8));

  SimpleStrokeDecoration.blackRadius10()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(10));

  SimpleStrokeDecoration.blackRadius16()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(16));

  SimpleStrokeDecoration.blackRadius24()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(24));

  SimpleStrokeDecoration.blackRadius32()
      : super(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(32));
}
