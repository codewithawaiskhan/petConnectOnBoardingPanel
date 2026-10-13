import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../features/admin_auth/presentation/providers/admin_auth_provider.dart';
import 'di/injector.dart' as di;

class AppInitializer with AppColors {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await di.setupInjector();

    await di.sl<AdminAuthProvider>().checkAuthStatus();

    debugPrint("PetConnect Portal initialized successfully!");
  }
}
