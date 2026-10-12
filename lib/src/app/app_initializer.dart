import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../features/admin_auth/presentation/providers/admin_auth_provider.dart';
import 'di/injector.dart' as di;

class AppInitializer with AppColors {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Core DI initialization (awaits SharedPreferences)
    await di.setupInjector();

    // 2. Pre-verify Auth status from persistent storage before app runs
    await di.sl<AdminAuthProvider>().checkAuthStatus();

    debugPrint("PetConnect Portal initialized successfully!");
  }
}
