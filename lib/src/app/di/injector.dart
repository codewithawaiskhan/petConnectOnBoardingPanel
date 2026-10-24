import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/api_services.dart';
import '../../features/admin_auth/di/admin_auth_injector.dart';
import '../../features/dashboard/di/dashboard_injector.dart';
import '../../features/lab_onboarding/di/lab_onboarding_injector.dart';
import '../../features/pet_parents/di/pet_parents_injector.dart';
import '../../features/resource_categories/di/resource_categories_injector.dart';
import '../../features/resources/di/resource_injector.dart';
import '../../features/service_provider_onboarding/di/service_provider_onboarding_injector.dart';
import '../../features/vet_onboarding/di/vet_onboarding_injector.dart';
import '../../shared/taxonomy/di/taxonomy_injector.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerLazySingleton<ApiServices>(() => ApiServices());

  initTaxonomyDependencies();

  initAdminAuthDependencies();
  initDashboardDependencies();
  initVetOnboardingDependencies();
  initServiceProviderOnboardingDependencies();
  initLabOnboardingDependencies();
  initPetParentsDependencies();
  initResourceCategoriesDependencies();
  initResourceDependencies();
}
