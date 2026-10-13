import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/presentation/layout/providers/sidebar_provider.dart';
import '../features/admin_auth/presentation/providers/admin_auth_provider.dart';
import '../features/dashboard/presentation/providers/dashboard_provider.dart';
import '../features/service_provider_onboarding/presentation/providers/service_provider_detail_provider.dart';
import '../features/service_provider_onboarding/presentation/providers/service_provider_onboarding_provider.dart';
import '../features/service_provider_onboarding/presentation/providers/service_providers_list_provider.dart';
import '../features/vet_onboarding/presentation/providers/doctor_onboarding_provider.dart';
import '../features/vet_onboarding/presentation/providers/vet_detail_provider.dart';
import '../features/vet_onboarding/presentation/providers/vets_list_provider.dart';
import 'di/injector.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<AdminAuthProvider>.value(
    value: sl<AdminAuthProvider>(),
  ),
  ChangeNotifierProvider<SidebarProvider>(create: (_) => SidebarProvider()),
  ChangeNotifierProvider<DashboardProvider>(
    create: (_) => sl<DashboardProvider>(),
  ),
  ChangeNotifierProvider<DoctorOnboardingProvider>(
    create: (_) => sl<DoctorOnboardingProvider>(),
  ),
  ChangeNotifierProvider<VetsListProvider>(
    create: (_) => sl<VetsListProvider>(),
  ),
  ChangeNotifierProvider<VetDetailProvider>(
    create: (_) => sl<VetDetailProvider>(),
  ),
  ChangeNotifierProvider<ServiceProviderOnboardingProvider>(
    create: (_) => sl<ServiceProviderOnboardingProvider>(),
  ),
  ChangeNotifierProvider<ServiceProvidersListProvider>(
    create: (_) => sl<ServiceProvidersListProvider>(),
  ),
  ChangeNotifierProvider<ServiceProviderDetailProvider>(
    create: (_) => sl<ServiceProviderDetailProvider>(),
  ),
];
