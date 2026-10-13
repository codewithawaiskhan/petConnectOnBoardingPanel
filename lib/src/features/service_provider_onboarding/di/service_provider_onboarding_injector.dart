import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../../../shared/taxonomy/domain/usecases/taxonomy_usecases.dart';
import '../data/data_sources/service_provider_onboarding_remote_data_source.dart';
import '../data/repositories/service_provider_onboarding_repository_impl.dart';
import '../domain/repositories/service_provider_onboarding_repository.dart';
import '../domain/usecases/service_provider_onboarding_usecases.dart';
import '../presentation/providers/service_provider_detail_provider.dart';
import '../presentation/providers/service_provider_onboarding_provider.dart';
import '../presentation/providers/service_providers_list_provider.dart';

void initServiceProviderOnboardingDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<ServiceProviderOnboardingRemoteDataSource>(
    () => ServiceProviderOnboardingRemoteDataSourceImpl(
      apiServices: sl<ApiServices>(),
    ),
  );

  sl.registerLazySingleton<ServiceProviderOnboardingRepository>(
    () => ServiceProviderOnboardingRepositoryImpl(
      remoteDataSource: sl<ServiceProviderOnboardingRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ServiceProviderOnboardingUseCases>(
    () => ServiceProviderOnboardingUseCases(
      repository: sl<ServiceProviderOnboardingRepository>(),
    ),
  );

  sl.registerFactory<ServiceProviderOnboardingProvider>(
    () => ServiceProviderOnboardingProvider(
      useCases: sl<ServiceProviderOnboardingUseCases>(),
      taxonomyUseCases: sl<TaxonomyUseCases>(),
    ),
  );

  sl.registerFactory<ServiceProvidersListProvider>(
    () => ServiceProvidersListProvider(
      useCases: sl<ServiceProviderOnboardingUseCases>(),
    ),
  );

  sl.registerFactory<ServiceProviderDetailProvider>(
    () => ServiceProviderDetailProvider(
      useCases: sl<ServiceProviderOnboardingUseCases>(),
    ),
  );
}
