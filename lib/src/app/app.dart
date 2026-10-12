import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import 'app_providers.dart';
import 'config/app_router.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget with AppColors {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp.router(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
