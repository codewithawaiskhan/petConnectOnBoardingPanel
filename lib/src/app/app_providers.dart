import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/presentation/layout/providers/sidebar_provider.dart';
import '../features/admin_auth/presentation/providers/admin_auth_provider.dart';
import '../features/service_provider_onboarding/presentation/providers/service_provider_onboarding_provider.dart';
import '../features/vet_onboarding/presentation/providers/doctor_onboarding_provider.dart';
import 'di/injector.dart';

// Global providers registered here as features are developed
List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider<AdminAuthProvider>.value(
    value: sl<AdminAuthProvider>(),
  ),
  ChangeNotifierProvider<SidebarProvider>(
    create: (_) => SidebarProvider(),
  ),
  ChangeNotifierProvider<DoctorOnboardingProvider>(
    create: (_) => sl<DoctorOnboardingProvider>(),
  ),
  ChangeNotifierProvider<ServiceProviderOnboardingProvider>(
    create: (_) => sl<ServiceProviderOnboardingProvider>(),
  ),
];
