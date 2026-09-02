import 'dart:convert';
import 'package:flutter/material.dart';

class SafeImage extends StatelessWidget {
  final String? imageSource;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String fallbackAsset;

  const SafeImage({
    super.key,
    required this.imageSource,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackAsset = 'assets/images/default_doctor.png',
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    final src = imageSource?.trim() ?? '';

    if (src.isEmpty) {
      content = Image.asset(
        fallbackAsset,
        width: width,
        height: height,
        fit: fit,
      );
    } else if (src.startsWith('assets/')) {
      content = Image.asset(
        src,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          fallbackAsset,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    } else if (src.startsWith('data:image')) {
      try {
        final clean = src.contains(',') ? src.split(',').last : src;
        content = Image.memory(
          base64Decode(clean),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            fallbackAsset,
            width: width,
            height: height,
            fit: fit,
          ),
        );
      } catch (_) {
        content = Image.asset(
          fallbackAsset,
          width: width,
          height: height,
          fit: fit,
        );
      }
    } else if (src.startsWith('http://') || src.startsWith('https://')) {
      content = Image.network(
        src,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          fallbackAsset,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    } else {
      content = Image.asset(
        fallbackAsset,
        width: width,
        height: height,
        fit: fit,
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: content);
    }
    return content;
  }
}

ImageProvider safeImageProvider(
  String? source, {
  String fallback = 'assets/images/default_doctor.png',
}) {
  final src = source?.trim() ?? '';
  if (src.isEmpty) {
    return AssetImage(fallback);
  }
  if (src.startsWith('assets/')) {
    return AssetImage(src);
  }
  if (src.startsWith('data:image')) {
    try {
      final clean = src.contains(',') ? src.split(',').last : src;
      return MemoryImage(base64Decode(clean));
    } catch (_) {
      return AssetImage(fallback);
    }
  }
  if (src.startsWith('http://') || src.startsWith('https://')) {
    return NetworkImage(src);
  }
  return AssetImage(fallback);
}
