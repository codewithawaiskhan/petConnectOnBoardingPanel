import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_assets.dart';

class AppLogo extends StatelessWidget {
  final double? size;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? size ?? 32.0;
    final effectiveHeight = height ?? size ?? 32.0;

    return Image.asset(
      AppAssets.appLogo,
      width: effectiveWidth,
      height: effectiveHeight,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return SvgPicture.asset(
          AppAssets.appIcon,
          width: effectiveWidth,
          height: effectiveHeight,
          fit: fit,
        );
      },
    );
  }
}
