import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/constants.dart';
import 'app_text.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final bool trimOnly;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 3,
    this.trimOnly = false,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> with AppColors, Constants {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: fontBaseText,
      height: 1.4,
      color: textPrimaryColor,
      fontWeight: FontWeight.w400,
    );

    final linkStyle = TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.w500,
      fontSize: fontBaseText,
      height: 1.4,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: textStyle);

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: widget.trimLines,
          textAlign: TextAlign.justify,
        );

        textPainter.layout(maxWidth: constraints.maxWidth);

        if (!textPainter.didExceedMaxLines) {
          return AppText(text: widget.text, style: textStyle, textAlign: TextAlign.justify);
        }

        if (widget.trimOnly) {
          return Text(
            widget.text,
            style: textStyle,
            maxLines: widget.trimLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.justify,
          );
        }

        if (isExpanded) {
          return RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: widget.text,
              style: textStyle,
              children: [
                TextSpan(
                  text: "  See Less",
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() => isExpanded = false);
                    },
                ),
              ],
            ),
          );
        }

        final linkSpan = TextSpan(text: "See More", style: linkStyle);
        final linkPainter = TextPainter(text: linkSpan, textDirection: TextDirection.ltr);
        linkPainter.layout(maxWidth: constraints.maxWidth);

        final position = textPainter.getPositionForOffset(
          Offset(constraints.maxWidth - linkPainter.width, textPainter.height),
        );

        final endOffset = textPainter.getOffsetBefore(position.offset) ?? position.offset;
        final firstHalf = widget.text.substring(0, endOffset);

        return RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: "$firstHalf... ",
            style: textStyle,
            children: [
              TextSpan(
                text: "See More",
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() => isExpanded = true);
                  },
              ),
            ],
          ),
        );
      },
    );
  }
}
