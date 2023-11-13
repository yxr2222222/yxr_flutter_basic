import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImage extends CachedNetworkImage {
  CacheImage._({required super.imageUrl});

  CacheImage.simple(
      {super.key,
      required String imageUrl,
      double width = double.infinity,
      double height = double.infinity,
      BoxFit fit = BoxFit.cover,
      Widget? placeholder,
      Widget? errorWidget})
      : super(
          width: width,
          height: height,
          fit: BoxFit.cover,
          imageUrl: imageUrl,
          placeholder: (context, url) =>
              placeholder ?? const Icon(Icons.downloading),
          errorWidget: (context, url, error) =>
              errorWidget ?? const Icon(Icons.error),
        );
}
