import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/constants.dart';
import 'app_text.dart';

class CustomTextButton extends StatelessWidget with AppColors, Constants {
  final String text;
  final double? textSize;
  final FontWeight? textWeight;
  final Color? textColor;
  final VoidCallback? onTap;

  CustomTextButton({
    super.key,
    required this.text,
    this.onTap,
    this.textSize,
    this.textWeight,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: Colors.transparent,
      ),
      child: AppText(
        text: text,
        fontSize: textSize ?? fontBaseText,
        fontWeight: textWeight ?? FontWeight.w500,
        color: textColor ?? primaryColor,
      ),
    );
  }
}
