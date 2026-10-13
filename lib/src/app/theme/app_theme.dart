import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class AppTheme with AppColors {
  static final AppTheme _instance = AppTheme._internal();
  factory AppTheme() => _instance;
  AppTheme._internal();

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontAeonik,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: whiteColor,
        secondary: secondaryColor,
        onSecondary: whiteColor,
        tertiary: tertiaryColor,
        onTertiary: whiteColor,
        error: errorColor,
        onError: whiteColor,
        surface: backgroundColor,
        onSurface: textPrimaryColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimaryColor),
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontFamily: fontAeonik,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerTheme: DividerThemeData(color: dividerColor, thickness: 1),
    );
  }
}
