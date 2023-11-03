import 'package:flutter/material.dart';

class SimpleWidget extends Container {
  final GestureTapCallback? onTap;

  SimpleWidget(
      {super.key,
      super.alignment,
      super.padding,
      super.color,
      super.decoration,
      super.foregroundDecoration,
      super.width,
      super.height,
      super.constraints,
      super.margin,
      super.transform,
      super.transformAlignment,
      super.child,
      super.clipBehavior = Clip.none,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: super.build(context),
      );
    }
    return super.build(context);
  }
}
