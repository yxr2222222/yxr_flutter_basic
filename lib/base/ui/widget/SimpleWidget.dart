import 'package:flutter/material.dart';

class SimpleWidget extends Container {
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongTap;
  final void Function()? onBuild;

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
      this.onTap,
      this.onDoubleTap,
      this.onLongTap,
      this.onBuild});

  @override
  Widget build(BuildContext context) {
    onBuild?.call();
    if (onTap != null || onDoubleTap != null || onLongTap != null) {
      return GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongTap,
        behavior: HitTestBehavior.opaque,
        child: super.build(context),
      );
    }
    return super.build(context);
  }
}
