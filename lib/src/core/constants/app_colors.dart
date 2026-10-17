import 'package:flutter/material.dart';

class AppColorsHelper with AppColors {}

mixin AppColors {
  Color get primaryColor => const Color(0xff2745B5);
  Color get secondaryColor => const Color(0xffFF6B6B);
  Color get tertiaryColor => const Color(0xff46C28E);

  Color get backgroundColor => const Color(0xffF4F6F6);
  Color get borderColor => const Color(0xffE8E9EA);
  Color get textPrimaryColor => const Color(0xff000000);
  Color get textSecondaryColor => const Color(0xff808080);
  Color get successColor => const Color(0xFF01761A);
  Color get lightGreenColor => const Color(0xFFD8F8D5);
  Color get skyBlueColor => const Color(0xFF5BAFC4);
  Color get lightSkyBlueColor => const Color(0xFFD4F1F9);
  Color get errorColor => const Color(0xffFF0000);
  Color get whiteColor => const Color(0xffffffff);
  Color get greyColor => const Color(0xff9D9D9D);
  Color get lightYellowColor => const Color(0xffFCF6BD);
  Color get purpleBlueColor => const Color(0xffC9CAFD);
  Color get softyBlueColor => const Color(0xffAEC8E2);
  Color get softSkyBlue => const Color(0xffAEC8E2);
  Color get androidGreenColor => const Color(0xff3DDC84);
  Color get iosDarkColor => const Color(0xff1C1C1E);
  Color get peachColor => const Color(0xffFBCFC3);
  Color get yellowColor => const Color(0xffF0AD34);
  Color get softGoldenColor => const Color(0xffFFDFA4);
  Color get dividerColor => const Color(0x26AEC8E2);
  Color get baseShimmerColor => const Color(0xff9D9D9D).withValues(alpha: 0.3);
  Color get highlightShimmerColor =>
      const Color(0xff9D9D9D).withValues(alpha: 0.1);

  Color get unSelectedIconColor => const Color(0xffB9BABD);

  Gradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryColor.withValues(alpha: 0.08), backgroundColor],
  );
}
