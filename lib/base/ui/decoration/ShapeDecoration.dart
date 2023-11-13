import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/config/ColorConfig.dart';

class ShapeDecoration extends BoxDecoration {
  const ShapeDecoration(
      {required Color color, BorderRadius radius = BorderRadius.zero})
      : super(color: color, borderRadius: radius);
  /// fffff
  ShapeDecoration.whiteRadius4()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(4));

  ShapeDecoration.whiteRadius8()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(8));

  ShapeDecoration.whiteRadius10()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(10));

  ShapeDecoration.whiteRadius16()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(16));

  ShapeDecoration.whiteRadius24()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(24));

  ShapeDecoration.whiteRadius32()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(32));

  /// f2f2f2
  ShapeDecoration.whiteF2f2f2Radius4()
      : super(color: ColorConfig.white_f2f2f2, borderRadius: BorderRadius.circular(4));

  ShapeDecoration.whiteF2f2f2Radius48()
      : super(color: ColorConfig.white_f2f2f2, borderRadius: BorderRadius.circular(8));

  ShapeDecoration.whiteF2f2f2Radius410()
      : super(color: ColorConfig.white_f2f2f2, borderRadius: BorderRadius.circular(10));

  ShapeDecoration.whiteF2f2f2Radius416()
      : super(color: ColorConfig.white_f2f2f2, borderRadius: BorderRadius.circular(16));

  ShapeDecoration.whiteF2f2f2Radius424()
      : super(color: ColorConfig.white_f2f2f2, borderRadius: BorderRadius.circular(24));

  ShapeDecoration.whiteF2f2f2Radius432()
      : super(color: ColorConfig.white_f2f2f2, borderRadius: BorderRadius.circular(32));

  /// 000000
  ShapeDecoration.blackRadius4()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(4));

  ShapeDecoration.blackRadius8()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(8));

  ShapeDecoration.blackRadius10()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(10));

  ShapeDecoration.blackRadius16()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(16));

  ShapeDecoration.blackRadius24()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(24));

  ShapeDecoration.blackRadius32()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(32));
}
