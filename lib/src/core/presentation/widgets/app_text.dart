import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';

class AppText extends StatelessWidget with AppColors {
  final String text;
  final String fontFamily;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final double? height;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final TextStyle? style;
  final bool isHtml;

  AppText({
    super.key,
    this.textAlign,
    this.height,
    this.overflow,
    this.maxLines,
    this.fontFamily = fontAeonik,
    this.textDirection,
    required this.text,
    this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.style,
    this.letterSpacing,
    this.isHtml = false,
  });

  @override
  Widget build(BuildContext context) {
    String parseHtml(String html) {
      String cleanedHtml = html
          .replaceAll(
            RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false),
            '',
          )
          .replaceAll(
            RegExp(r'<title[^>]*>[\s\S]*?</title>', caseSensitive: false),
            '',
          );

      cleanedHtml = cleanedHtml
          .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
          .replaceAll(
            RegExp(r'</p>|</div>|</li>', caseSensitive: false),
            '\n\n',
          );

      final document = html_parser.parse(cleanedHtml);
      String parsedText =
          document.body?.text ?? document.documentElement?.text ?? "";

      parsedText = parsedText.replaceAll(RegExp(r'\n{3,}'), '\n\n');

      return parsedText.trim();
    }

    return Text(
      isHtml ? parseHtml(text) : text,
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      style:
          style ??
          TextStyle(
            fontSize: fontSize ?? 12,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            color: color ?? textPrimaryColor,
            letterSpacing: letterSpacing,
            height: height,
          ),
    );
  }
}
