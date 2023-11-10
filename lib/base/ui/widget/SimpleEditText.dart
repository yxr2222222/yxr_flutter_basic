import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/config/ColorConfig.dart';

class SimpleEditText extends StatelessWidget {
  static const _padding = EdgeInsets.only(right: 16, top: 14, bottom: 14);
  static const _margin = EdgeInsets.only(left: 16, right: 16);
  final int height;
  final Color background;
  final double borderRadius;
  final double fontSize;
  final Color fontColor;
  final Color hintColor;
  final String? hintText;
  final String? prefixIcon;
  final String? suffixIcon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  SimpleEditText(
      {this.height = 48,
      this.background = ColorConfig.white_f2f2f2,
      this.borderRadius = 4,
      this.fontSize = 16,
      this.fontColor = ColorConfig.black_5c5c5c,
      this.hintColor = ColorConfig.gray_999999,
      this.hintText = "请输入内容",
      this.prefixIcon =
          "packages/yxr_flutter_basic/lib/images/icon_search_gray.png",
      this.suffixIcon,
      this.padding = _padding,
      this.margin = _margin,
      this.controller,
      this.onSubmitted,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(borderRadius)),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: fontSize,
          color: fontColor,
        ),
        decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            hintStyle: TextStyle(color: hintColor, fontSize: fontSize),
            prefixIcon: prefixIcon == null ? null : Image.asset(prefixIcon!),
            suffixIcon: suffixIcon == null ? null : Image.asset(suffixIcon!)),
      ),
    );
  }
}
