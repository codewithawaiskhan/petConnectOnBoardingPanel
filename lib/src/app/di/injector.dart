import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_services.dart';
import '../../features/admin_auth/di/admin_auth_injector.dart';
import '../../features/service_provider_onboarding/di/service_provider_onboarding_injector.dart';
import '../../features/vet_onboarding/di/vet_onboarding_injector.dart';
import '../../shared/taxonomy/di/taxonomy_injector.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  // 1. Core Infrastructure & External Services
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerLazySingleton<ApiServices>(() => ApiServices());

  // 2. Shared Core Infrastructure
  initTaxonomyDependencies();

  // 3. Modular Feature Dependencies
  initAdminAuthDependencies();
  initVetOnboardingDependencies();
  initServiceProviderOnboardingDependencies();
}
