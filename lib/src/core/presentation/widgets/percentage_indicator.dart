import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../constants/app_colors.dart';
import '../../constants/constants.dart';

class PercentageIndicator extends StatelessWidget with AppColors, Constants {
  final double percent;

  PercentageIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      padding: EdgeInsets.zero,
      lineHeight: smallSpace,
      percent: percent.clamp(0.0, 1.0),
      progressColor: primaryColor,
      backgroundColor: borderColor,
      barRadius: Radius.circular(radiusExtraLarge),
    );
  }
}
