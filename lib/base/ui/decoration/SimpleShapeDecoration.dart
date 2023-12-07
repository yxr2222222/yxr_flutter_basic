import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/config/ColorConfig.dart';

class SimpleShapeDecoration extends BoxDecoration {
  const SimpleShapeDecoration(
      {required Color color, BorderRadius radius = BorderRadius.zero})
      : super(color: color, borderRadius: radius);

  /// fffff
  SimpleShapeDecoration.whiteRadius4()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(4));

  SimpleShapeDecoration.whiteRadius8()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(8));

  SimpleShapeDecoration.whiteRadius10()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(10));

  SimpleShapeDecoration.whiteRadius16()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(16));

  SimpleShapeDecoration.whiteRadius24()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(24));

  SimpleShapeDecoration.whiteRadius32()
      : super(color: Colors.white, borderRadius: BorderRadius.circular(32));

  /// f2f2f2
  SimpleShapeDecoration.whiteF2f2f2Radius4()
      : super(
            color: ColorConfig.white_f2f2f2,
            borderRadius: BorderRadius.circular(4));

  SimpleShapeDecoration.whiteF2f2f2Radius48()
      : super(
            color: ColorConfig.white_f2f2f2,
            borderRadius: BorderRadius.circular(8));

  SimpleShapeDecoration.whiteF2f2f2Radius410()
      : super(
            color: ColorConfig.white_f2f2f2,
            borderRadius: BorderRadius.circular(10));

  SimpleShapeDecoration.whiteF2f2f2Radius416()
      : super(
            color: ColorConfig.white_f2f2f2,
            borderRadius: BorderRadius.circular(16));

  SimpleShapeDecoration.whiteF2f2f2Radius424()
      : super(
            color: ColorConfig.white_f2f2f2,
            borderRadius: BorderRadius.circular(24));

  SimpleShapeDecoration.whiteF2f2f2Radius432()
      : super(
            color: ColorConfig.white_f2f2f2,
            borderRadius: BorderRadius.circular(32));

  /// 000000
  SimpleShapeDecoration.blackRadius4()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(4));

  SimpleShapeDecoration.blackRadius8()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(8));

  SimpleShapeDecoration.blackRadius10()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(10));

  SimpleShapeDecoration.blackRadius16()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(16));

  SimpleShapeDecoration.blackRadius24()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(24));

  SimpleShapeDecoration.blackRadius32()
      : super(color: Colors.black, borderRadius: BorderRadius.circular(32));

  /// 简单的阴影
  static BoxShadow simpleShadow() {
    return BoxShadow(
      color: Colors.black.withOpacity(0.2), // 阴影颜色
      offset: const Offset(0, 2), // 阴影偏移量
      blurRadius: 1, // 阴影模糊程度
      spreadRadius: 0, // 阴影扩散程度
    );
  }
}
