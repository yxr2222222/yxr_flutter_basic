import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yxr_flutter_basic/base/ui/decoration/SimpleStrokeDecoration.dart';

class CacheImage {
  CacheImage._();

  static Widget simple({
    required String imageUrl,
    double width = double.infinity,
    double height = double.infinity,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color borderColor = Colors.white,
  }) {
    var image = CachedNetworkImage(
      width: width,
      height: height,
      fit: fit,
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          placeholder ?? const Icon(Icons.downloading),
      errorWidget: (context, url, error) =>
          errorWidget ?? const Icon(Icons.error),
    );

    return Stack(
      children: _getImages(
        image,
        borderRadius,
        borderWidth,
        borderColor,
        width,
        height,
      ),
    );
  }

  static List<Widget> _getImages(
    CachedNetworkImage image,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color borderColor,
    double width,
    double height,
  ) {
    List<Widget> children = [];
    children.add(borderRadius == null
        ? image
        : ClipRRect(
            borderRadius: borderRadius,
            child: image,
          ));

    if (borderWidth != null && borderWidth > 0) {
      children.add(Container(
        width: width,
        height: height,
        decoration: SimpleStrokeDecoration(
          borderColor: borderColor,
          strokeWidth: borderWidth,
          radius: borderRadius ?? BorderRadius.zero,
        ),
      ));
    }
    return children;
  }
}
