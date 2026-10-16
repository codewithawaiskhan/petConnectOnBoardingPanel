import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/constants.dart';
import 'app_text.dart';

class CustomButton extends StatelessWidget with AppColors, Constants {
  CustomButton({
    super.key,
    required this.text,
    this.isIcon = false,
    this.icon,
    this.width = 0,
    this.fontHeight,
    this.fontWeight = FontWeight.w600,
    this.textColor,
    this.gradient,
    this.radius,
    this.textAlign = TextAlign.center,
    this.height = 56,
    this.fontSize = 16,
    this.isOutlined = false,
    this.fillColor,
    this.isFill = true,
    this.isLoading = false,
    this.onTap,
    this.fontFamily,
    this.maxLines,
    this.softWrap = true,
    this.fontStyle = FontStyle.normal,
    this.padding,
    this.buttonBorder,
    this.iconAlignment = false,
    this.subtitle,
  });

  final double width;
  final double fontSize;
  final double? height;
  final double? fontHeight;
  final double? radius;
  final String text;
  final bool isFill;
  final bool isOutlined;
  final bool isLoading;
  final Color? fillColor;
  final Color? textColor;
  final FontWeight fontWeight;
  final VoidCallback? onTap;
  final bool isIcon;
  final Widget? icon;
  final TextAlign textAlign;
  final Gradient? gradient;
  final String? fontFamily;
  final int? maxLines;
  final bool softWrap;
  final FontStyle? fontStyle;
  final EdgeInsets? padding;
  final Border? buttonBorder;
  final bool iconAlignment;
  final String? subtitle;

  Color get effectiveTextColor =>
      textColor ?? ((isOutlined || !isFill) ? primaryColor : whiteColor);

  @override
  Widget build(BuildContext context) {
    final double effectiveRadius = radius ?? radiusLarge;
    final bool isClickable = !isLoading && onTap != null;

    final Color effectiveBgColor = isOutlined
        ? Colors.transparent
        : (isFill ? (fillColor ?? primaryColor) : Colors.transparent);

    final Border? effectiveBorder = isOutlined
        ? (buttonBorder ?? Border.all(color: primaryColor, width: 1.5))
        : buttonBorder;

    return SizedBox(
      height: height,
      width: width == 0 ? null : width,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(effectiveRadius),
          onTap: isClickable ? onTap : null,
          child: Ink(
            height: height,
            width: width == 0 ? null : width,
            decoration: BoxDecoration(
              color: effectiveBgColor,
              borderRadius: BorderRadius.circular(effectiveRadius),
              border: effectiveBorder,
              gradient: (isOutlined || isFill) ? null : gradient,
            ),
            child: Container(
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              alignment: Alignment.center,
              child: isLoading
                  ? SpinKitThreeBounce(color: effectiveTextColor, size: 24.0)
                  : _buildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isIcon) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Flexible(child: textWidget()),
        ],
      );
    } else {
      return textWidget();
    }
  }

  Widget textWidget() {
    return AppText(
      text: text,
      fontSize: fontSize,
      color: effectiveTextColor,
      fontWeight: fontWeight,
      textAlign: textAlign,
      fontFamily: fontFamily ?? fontAeonik,
      maxLines: maxLines ?? 1,
      height: fontHeight,
      overflow: TextOverflow.visible,
    );
  }
}
