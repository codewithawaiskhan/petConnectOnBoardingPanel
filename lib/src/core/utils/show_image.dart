import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../app/config/api_endpoints.dart';
import '../constants/app_colors.dart';

class ShowImage with ApiEndpoints, AppColors {
  Widget _buildCachedNetworkImage(
    String url,
    double? w,
    double? h,
    BoxFit fit,
    double? radius,
    String? errorImage,
  ) {
    final cacheW = (w != null && w != double.infinity) ? (w * 2).toInt() : null;
    final cacheH = (h != null && h != double.infinity) ? (h * 2).toInt() : null;

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: w,
      height: h,
      memCacheWidth: cacheW,
      memCacheHeight: cacheH,
      placeholder: (context, url) => _shimmerWidget(w, h, radius),
      errorWidget: (context, url, error) {
        if (errorImage != null) {
          return CachedNetworkImage(
            imageUrl: errorImage,
            width: w,
            height: h,
            fit: fit,
          );
        }
        return _errorWidget(w, h, radius);
      },
    );
  }

  Widget buildImage({
    required String? image,
    double? radius,
    double? size,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String? errorImage,
    bool isAsset = false,
  }) {
    final imageWidth = width ?? size;
    final imageHeight = height ?? size;

    if (image == null || image.isEmpty) {
      return _applyClipping(
        _errorWidget(imageWidth, imageHeight, radius),
        radius,
      );
    }

    final isBase64 = image.startsWith("data:image");
    Widget content;

    try {
      if (isBase64) {
        final base64String = image.split(',').last;
        final bytes = base64Decode(base64String);
        content = Image.memory(
          bytes,
          fit: fit,
          width: imageWidth,
          height: imageHeight,
          cacheWidth: (imageWidth != null ? (imageWidth * 2).toInt() : 200)
              .clamp(50, 400),
          cacheHeight: (imageHeight != null ? (imageHeight * 2).toInt() : 200)
              .clamp(50, 400),
          gaplessPlayback: true,
          errorBuilder: (_, _, _) =>
              _errorWidget(imageWidth, imageHeight, radius),
        );
      } else if (isAsset) {
        content = Image.asset(
          image,
          fit: fit,
          width: imageWidth,
          height: imageHeight,
          errorBuilder: (_, _, _) =>
              _errorWidget(imageWidth, imageHeight, radius),
        );
      } else {
        final isFullUrl =
            image.startsWith("http://") || image.startsWith("https://");
        final cleanPath = image.startsWith('/') ? image.substring(1) : image;
        final imageUrl =
            isFullUrl ? image : "${ApiEndpoints.storageBaseUrl}/$cleanPath";

        content = _buildCachedNetworkImage(
          imageUrl,
          imageWidth,
          imageHeight,
          fit,
          radius,
          errorImage,
        );
      }
    } catch (e) {
      content = _errorWidget(imageWidth, imageHeight, radius);
    }

    return _applyClipping(content, radius);
  }

  Widget _applyClipping(Widget child, double? radius) {
    if (radius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: child,
      );
    } else {
      return ClipOval(child: child);
    }
  }

  static Widget _errorWidget(double? width, double? height, double? radius) {
    return Container(
      width: width ?? 50,
      height: height ?? 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: radius == null ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: radius != null ? BorderRadius.circular(radius) : null,
      ),
      child: const Icon(Icons.image_rounded, color: Colors.grey, size: 24),
    );
  }

  Widget _shimmerWidget(double? width, double? height, double? radius) {
    return Container(
      width: width ?? 50,
      height: height ?? 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: radius == null ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: radius != null ? BorderRadius.circular(radius) : null,
      ),
    );
  }
}
