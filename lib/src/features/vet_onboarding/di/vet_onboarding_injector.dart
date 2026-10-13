import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../../../shared/taxonomy/domain/usecases/taxonomy_usecases.dart';
import '../data/data_sources/vet_onboarding_remote_data_source.dart';
import '../data/repositories/vet_onboarding_repository_impl.dart';
import '../domain/repositories/vet_onboarding_repository.dart';
import '../domain/usecases/vet_onboarding_usecases.dart';
import '../presentation/providers/doctor_onboarding_provider.dart';
import '../presentation/providers/vet_detail_provider.dart';
import '../presentation/providers/vets_list_provider.dart';

void initVetOnboardingDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<VetOnboardingRemoteDataSource>(
    () => VetOnboardingRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<VetOnboardingRepository>(
    () => VetOnboardingRepositoryImpl(
      remoteDataSource: sl<VetOnboardingRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<VetOnboardingUseCases>(
    () => VetOnboardingUseCases(repository: sl<VetOnboardingRepository>()),
  );

  sl.registerFactory<DoctorOnboardingProvider>(
    () => DoctorOnboardingProvider(
      useCases: sl<VetOnboardingUseCases>(),
      taxonomyUseCases: sl<TaxonomyUseCases>(),
    ),
  );

  sl.registerFactory<VetsListProvider>(
    () => VetsListProvider(useCases: sl<VetOnboardingUseCases>()),
  );

  sl.registerFactory<VetDetailProvider>(
    () => VetDetailProvider(useCases: sl<VetOnboardingUseCases>()),
  );
}
