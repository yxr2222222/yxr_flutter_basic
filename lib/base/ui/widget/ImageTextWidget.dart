import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/style/SimpleTextStyle.dart';
import 'package:yxr_flutter_basic/base/ui/widget/SimpleWidget.dart';

class ImageTextWidget extends StatelessWidget {
  final ImageOrientation imageOrientation;
  final double imageWidth;
  final double imageHeight;
  final String imageRes;
  final String text;
  final TextStyle? textStyle;
  final double imageTextPadding;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureLongPressCallback? onLongTap;

  const ImageTextWidget({
    super.key,
    required this.imageRes,
    required this.text,
    this.imageOrientation = ImageOrientation.left,
    this.imageWidth = 20,
    this.imageHeight = 20,
    this.textStyle,
    this.imageTextPadding = 4,
    this.alignment = Alignment.center,
    this.padding,
    this.decoration,
    this.width,
    this.height,
    this.margin,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleWidget(
      alignment: alignment,
      padding: padding,
      decoration: decoration,
      margin: margin,
      width: width,
      height: height,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongTap: onLongTap,
      child: ImageOrientation.left == imageOrientation ||
              ImageOrientation.right == imageOrientation
          ? _buildRowWidget()
          : _buildColumnWidget(),
    );
  }

  Widget _buildRowWidget() {
    List<Widget> children = [];
    if (ImageOrientation.left == imageOrientation) {
      children.add(_buildImageWidget());
      children.add(_buildPadding(left: imageTextPadding));
      children.add(_buildTextWidget());
    } else {
      children.add(_buildTextWidget());
      children.add(_buildPadding(left: imageTextPadding));
      children.add(_buildImageWidget());
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildColumnWidget() {
    List<Widget> children = [];
    if (ImageOrientation.top == imageOrientation) {
      children.add(_buildImageWidget());
      children.add(_buildPadding(top: imageTextPadding));
      children.add(_buildTextWidget());
    } else {
      children.add(_buildTextWidget());
      children.add(_buildPadding(top: imageTextPadding));
      children.add(_buildImageWidget());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildImageWidget() => Image.asset(
        imageRes,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.cover,
      );

  Widget _buildTextWidget() => Text(
        text,
        style: textStyle ?? const SimpleTextStyle.normal_12(),
      );

  Widget _buildPadding({
    double left = 0,
    double top = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: left,
          top: top,
        ),
      );
}

enum ImageOrientation { left, top, right, bottom }
