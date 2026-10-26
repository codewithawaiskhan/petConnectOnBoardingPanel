import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/presentation/layout/dashboard_shell.dart';
import '../../features/admin_auth/presentation/providers/admin_auth_provider.dart';
import '../../features/admin_auth/presentation/screens/admin_login_screen.dart';
import '../../features/admin_auth/presentation/screens/splash_loading_screen.dart';
import '../../features/campaigns/presentation/screens/campaigns_list_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_home_screen.dart';
import '../../features/lab_onboarding/presentation/screens/lab_detail_screen.dart';
import '../../features/lab_onboarding/presentation/screens/lab_onboarding_screen.dart';
import '../../features/lab_onboarding/presentation/screens/labs_list_screen.dart';
import '../../features/pet_parents/presentation/screens/pet_parent_detail_screen.dart';
import '../../features/pet_parents/presentation/screens/pet_parents_list_screen.dart';
import '../../features/resource_categories/presentation/screens/resource_categories_list_screen.dart';
import '../../features/resources/presentation/screens/resource_detail_screen.dart';
import '../../features/resources/presentation/screens/resources_list_screen.dart';
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
              path: '/pet-parents',
              name: 'pet-parents',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: PetParentsListScreen()),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'pet-parent-detail',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return NoTransitionPage(
                      child: PetParentDetailScreen(id: id),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/pet-parents-list',
              redirect: (context, state) => '/pet-parents',
            ),
            GoRoute(
              path: '/pet-parents-list/:id',
              redirect: (context, state) =>
                  '/pet-parents/${state.pathParameters['id']}',
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/vets',
              name: 'vets',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: VetsListScreen()),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'vet-detail',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return NoTransitionPage(child: VetDetailScreen(id: id));
                  },
                ),
              ],
            ),
            GoRoute(path: '/vets-list', redirect: (context, state) => '/vets'),
            GoRoute(
              path: '/vets-list/:id',
              redirect: (context, state) =>
                  '/vets/${state.pathParameters['id']}',
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
              path: '/providers',
              name: 'providers',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ServiceProvidersListScreen()),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'provider-detail',
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
              path: '/service-providers-list',
              redirect: (context, state) => '/providers',
            ),
            GoRoute(
              path: '/service-providers-list/:id',
              redirect: (context, state) =>
                  '/providers/${state.pathParameters['id']}',
            ),
            GoRoute(
              path: '/service-providers/:id',
              redirect: (context, state) =>
                  '/providers/${state.pathParameters['id']}',
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
              path: '/labs',
              name: 'labs',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: LabsListScreen()),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'lab-detail',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return NoTransitionPage(child: LabDetailScreen(id: id));
                  },
                ),
              ],
            ),
            GoRoute(path: '/labs-list', redirect: (context, state) => '/labs'),
            GoRoute(
              path: '/labs-list/:id',
              redirect: (context, state) =>
                  '/labs/${state.pathParameters['id']}',
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/diagnostic-labs',
              name: 'diagnostic-labs',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: LabOnboardingScreen()),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/resource-categories',
              name: 'resource-categories',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ResourceCategoriesListScreen()),
            ),
            GoRoute(
              path: '/post-categories',
              redirect: (context, state) => '/resource-categories',
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/resources',
              name: 'resources',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ResourcesListScreen()),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'resource-detail',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return NoTransitionPage(
                      child: ResourceDetailScreen(id: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/campaigns',
              name: 'campaigns',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: CampaignsListScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
