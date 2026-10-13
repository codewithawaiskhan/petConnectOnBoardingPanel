import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/presentation/layout/dashboard_shell.dart';
import '../../features/admin_auth/presentation/providers/admin_auth_provider.dart';
import '../../features/admin_auth/presentation/screens/admin_login_screen.dart';
import '../../features/admin_auth/presentation/screens/splash_loading_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_home_screen.dart';
import '../../features/lab_onboarding/presentation/screens/lab_placeholder_screen.dart';
import '../../features/service_provider_onboarding/presentation/screens/service_provider_detail_screen.dart';
import '../../features/service_provider_onboarding/presentation/screens/service_provider_onboarding_screen.dart';
import '../../features/service_provider_onboarding/presentation/screens/service_providers_list_screen.dart';
import '../../features/vet_onboarding/presentation/screens/vet_detail_screen.dart';
import '../../features/vet_onboarding/presentation/screens/vet_onboarding_screen.dart';
import '../../features/vet_onboarding/presentation/screens/vets_list_screen.dart';
import '../di/injector.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

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

    if (isInitializing) {
      if (isSplash) return null;

      final currentTarget =
          state.matchedLocation.isNotEmpty && state.matchedLocation != '/'
          ? state.matchedLocation
          : '/dashboard';
      return '/splash?redirect=${Uri.encodeComponent(currentTarget)}';
    }

    final redirectParam = state.uri.queryParameters['redirect'];
    final destination =
        (redirectParam != null &&
            redirectParam.isNotEmpty &&
            redirectParam != '/login' &&
            redirectParam != '/splash')
        ? redirectParam
        : '/dashboard';

    if (!isLoggedIn) {
      return isLoggingIn ? null : '/login';
    }

    if (isLoggingIn || isSplash || state.matchedLocation == '/') {
      return destination;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SplashLoadingScreen()),
    ),
    GoRoute(path: '/', redirect: (context, state) => '/dashboard'),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AdminLoginScreen()),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DashboardShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: DashboardHomeScreen()),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/doctors',
              name: 'doctors',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: VetOnboardingScreen()),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/vets-list',
              name: 'vets-list',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: VetsListScreen()),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'vets-list-detail',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return NoTransitionPage(child: VetDetailScreen(id: id));
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/vets/:id',
              name: 'vet-detail',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id'] ?? '';
                return NoTransitionPage(child: VetDetailScreen(id: id));
              },
            ),
          ],
        ),

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

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/service-providers-list',
              name: 'service-providers-list',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ServiceProvidersListScreen()),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'service-providers-list-detail',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return NoTransitionPage(
                      child: ServiceProviderDetailScreen(id: id),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/service-providers/:id',
              name: 'service-provider-detail',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id'] ?? '';
                return NoTransitionPage(
                  child: ServiceProviderDetailScreen(id: id),
                );
              },
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/labs',
              name: 'labs',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: LabPlaceholderScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
