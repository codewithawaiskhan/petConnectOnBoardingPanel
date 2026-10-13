import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/constants.dart';
import 'app_text.dart';

typedef CustomTextField = CustomTextFormField;

class CustomTextFormField extends StatefulWidget {
  final double? width;
  final String? hintText;
  final bool isObSecure;
  final double paddingSize;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isIcon;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final bool isEnable;
  final int? maxLength;
  final void Function(String)? onChanged;
  final Color? fillColor;
  final bool readOnly;
  final double radius;
  final String? title;
  final bool filled;
  final Color? textColor;
  final TextAlign textAlign;
  final double? titleTextSize;
  final String? initialValue;
  final FocusNode? focusNode;
  final Color? enableBorderColor;
  final Color? focusBorderColor;
  final Color? disabledBorderColor;
  final Color? titleColor;
  final GestureTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final String? suffixText;
  final AutovalidateMode? autoValidateMode;
  final TextEditingController? controller;
  final bool hasBorder;
  final Color? cursorColor;

  const CustomTextFormField({
    super.key,
    this.width,
    this.hintText,
    this.title,
    this.prefixIcon,
    this.filled = false,
    this.onChanged,
    this.isEnable = true,
    this.suffixIcon,
    this.fillColor,
    this.isIcon = false,
    this.isObSecure = false,
    this.textInputType,
    this.paddingSize = 12,
    this.radius = 30,
    this.validator,
    this.readOnly = false,
    this.controller,
    this.maxLength,
    this.textColor,
    this.textAlign = TextAlign.left,
    this.titleTextSize,
    this.initialValue,
    this.focusNode,
    this.enableBorderColor,
    this.focusBorderColor,
    this.disabledBorderColor,
    this.titleColor,
    this.onTap,
    this.maxLines,
    this.inputFormatters,
    this.suffixText,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.hasBorder = true,
    this.cursorColor,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField>
    with AppColors, Constants {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.radius);

    InputDecoration buildDecoration() {
      return InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: textSecondaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: fontAeonik,
        ),
        prefixIcon: widget.isIcon && widget.prefixIcon != null
            ? Padding(
                padding: EdgeInsets.all(widget.paddingSize),
                child: widget.prefixIcon,
              )
            : null,
        suffixIcon: widget.isObSecure
            ? IconButton(
                onPressed: () => setState(() => obscure = !obscure),
                icon: SvgPicture.asset(
                  obscure ? AppAssets.eyeClosedIcon : AppAssets.eyeIcon,
                  width: iconSize,
                  height: iconSize,
                ),
              )
            : widget.suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: widget.suffixIcon,
              )
            : null,
        suffixText: widget.suffixText,
        counterText: "",
        filled: true,
        fillColor: (widget.isEnable || widget.filled)
            ? widget.fillColor ?? whiteColor
            : borderColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.isIcon ? 5 : 15,
          vertical: 15,
        ),
        border: widget.hasBorder
            ? OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: borderColor, width: border),
              )
            : InputBorder.none,
        enabledBorder: widget.hasBorder
            ? OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: widget.enableBorderColor ?? borderColor,
                  width: border,
                ),
              )
            : InputBorder.none,
        focusedBorder: widget.hasBorder
            ? OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: widget.focusBorderColor ?? primaryColor,
                  width: border,
                ),
              )
            : InputBorder.none,
        disabledBorder: widget.hasBorder
            ? OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: widget.disabledBorderColor ?? borderColor,
                  width: border,
                ),
              )
            : InputBorder.none,
      );
    }

    Widget textField() {
      return TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onTap: widget.onTap,
        keyboardType: widget.textInputType,
        validator: widget.validator,
        enabled: widget.isEnable,
        readOnly: widget.readOnly,
        cursorColor: widget.cursorColor ?? primaryColor,
        style: TextStyle(
          color: widget.textColor ?? textPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: fontAeonik,
        ),
        textAlign: widget.textAlign,
        obscureText: widget.isObSecure ? obscure : false,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines ?? 1,
        initialValue: widget.initialValue,
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatters,
        autovalidateMode: widget.autoValidateMode,
        decoration: buildDecoration(),
      );
    }

    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      child: widget.title == null
          ? textField()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: AppText(
                    text: widget.title!,
                    color: widget.titleColor ?? textPrimaryColor,
                    fontSize: widget.titleTextSize ?? 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: fontAeonik,
                  ),
                ),
                textField(),
              ],
            ),
    );
  }
}
