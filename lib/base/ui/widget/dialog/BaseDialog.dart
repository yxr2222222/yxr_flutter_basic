import 'package:flutter/material.dart';

class BaseDialog extends Dialog {
  BaseDialog({
    super.key,
    required Widget child,
    Color? backgroundColor = Colors.transparent,
    Alignment alignment = Alignment.center,
    double elevation = 0,
  }) : super(
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: elevation,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: backgroundColor,
              alignment: Alignment.center,
              child: child,
            ));
}
