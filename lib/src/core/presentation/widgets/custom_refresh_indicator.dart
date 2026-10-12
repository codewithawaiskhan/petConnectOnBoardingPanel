import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CustomRefreshIndicator extends StatelessWidget with AppColors {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: whiteColor,
      backgroundColor: primaryColor,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
