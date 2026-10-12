import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/presentation/layout/dashboard_shell.dart';
import '../../features/admin_auth/presentation/providers/admin_auth_provider.dart';
import '../../features/admin_auth/presentation/screens/admin_login_screen.dart';
import '../../features/admin_auth/presentation/screens/splash_loading_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_home_screen.dart';
import '../../features/lab_onboarding/presentation/screens/lab_placeholder_screen.dart';
import '../../features/service_provider_onboarding/presentation/screens/service_provider_onboarding_screen.dart';
import '../../features/vet_onboarding/presentation/screens/vet_onboarding_screen.dart';

import '../di/injector.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  refreshListenable: sl<AdminAuthProvider>(),
  redirect: (BuildContext context, GoRouterState state) {
    final authProvider = sl<AdminAuthProvider>();
    final isInitializing = authProvider.isInitializing;
    final isLoggedIn = authProvider.isLoggedIn;
    final isSplash = state.matchedLocation == '/splash';
    final isLoggingIn = state.matchedLocation == '/login';

    // 1. If currently checking JWT token from persistent storage
    if (isInitializing) {
      if (isSplash) return null;
      // Preserve target destination in query parameter so we return to it once initialized
      final currentTarget = state.matchedLocation.isNotEmpty && state.matchedLocation != '/'
          ? state.matchedLocation
          : '/dashboard';
      return '/splash?redirect=${Uri.encodeComponent(currentTarget)}';
    }

    // 2. Initialization complete: Determine target if returning from splash
    final redirectParam = state.uri.queryParameters['redirect'];
    final destination = (redirectParam != null &&
            redirectParam.isNotEmpty &&
            redirectParam != '/login' &&
            redirectParam != '/splash')
        ? redirectParam
        : '/dashboard';

    // If user is NOT logged in:
    if (!isLoggedIn) {
      return isLoggingIn ? null : '/login';
    }

    // If user IS logged in:
    // If on /login, /splash, or '/', redirect to target destination
    if (isLoggingIn || isSplash || state.matchedLocation == '/') {
      return destination;
    }

    // Allow navigation to requested route
    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SplashLoadingScreen(),
      ),
    ),
    GoRoute(
      path: '/',
      redirect: (context, state) => '/dashboard',
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: AdminLoginScreen(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DashboardShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Dashboard Overview
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: DashboardHomeScreen(),
              ),
            ),
          ],
        ),
        // Branch 1: Doctors / Vet Onboarding
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/doctors',
              name: 'doctors',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: VetOnboardingScreen(),
              ),
            ),
          ],
        ),
        // Branch 2: Service Providers
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/service-providers',
              name: 'service-providers',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ServiceProviderOnboardingScreen(),
              ),
            ),
          ],
        ),
        // Branch 3: Diagnostic Labs
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/labs',
              name: 'labs',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: LabPlaceholderScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

