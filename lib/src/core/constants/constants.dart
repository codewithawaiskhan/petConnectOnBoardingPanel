import 'package:flutter/material.dart';

class AppConstantsHelper with Constants {}

mixin Constants {
  // Font sizes
  double get fontXsText => 10.0;
  double get fontSmText => 12.0;
  double get fontBaseText => 14.0;
  double get fontLgText => 16.0;
  double get fontXlText => 18.0;
  double get font2xlText => 20.0;
  double get font3xlText => 24.0;
  double get font4xlText => 28.0;
  double get font5xlText => 36.0;
  double get font6xlText => 48.0;
  double get font7xlText => 60.0;

  // Button height
  double get buttonHeightSmall => 40.0;
  double get buttonHeight => 50.0;

  // Radius
  double get radiusSmall => 12.0;
  double get radiusMedium => 15.0;
  double get radiusLarge => 30.0;
  double get radiusExtraLarge => 50.0;
  double get radiusXXL => 65.0;
  double get radiusMax => 100.0;

  // Spaces
  double get zeroSpace => 0.0;
  double get xxsSpace => 4.0;
  double get xsSpace => 6.0;
  double get smallSpace => 8.0;
  double get mediumSpace => 10.0;
  double get smMediumSpace => 12.0;
  double get normalSpace => 16.0;
  double get largeSpace => 20.0;
  double get extraLargeSpace => 34.0;
  double get xxLargeSpace => 48.0;
  double get xxxLargeSpace => 70.0;
  double get xxxxLargeSpace => 100.0;

  // Border
  double get smallBorder => 0.5;
  double get border => 1.0;
  double get largeBorder => 1.5;
  double get extraLargeBorder => 2.0;

  // Icon size
  double get smallIconSize => 15.0;
  double get iconSize => 24.0;
  double get barIconSize => 30.0;

  // Paddings
  final smallHorizontalPadding = const EdgeInsets.symmetric(horizontal: 8.0);
  final mediumHorizontalPadding = const EdgeInsets.symmetric(horizontal: 12.0);
  final horizontalPadding = const EdgeInsets.symmetric(horizontal: 16.0);
  final largeHorizontalPadding = const EdgeInsets.symmetric(horizontal: 22.0);
  final verticalPadding = const EdgeInsets.symmetric(vertical: 16.0);
}
