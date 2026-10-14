import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../../../shared/taxonomy/domain/usecases/taxonomy_usecases.dart';
import '../data/data_sources/lab_onboarding_remote_data_source.dart';
import '../data/repositories/lab_onboarding_repository_impl.dart';
import '../domain/repositories/lab_onboarding_repository.dart';
import '../domain/usecases/lab_onboarding_usecases.dart';
import '../presentation/providers/lab_detail_provider.dart';
import '../presentation/providers/lab_onboarding_provider.dart';
import '../presentation/providers/labs_list_provider.dart';

void initLabOnboardingDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<LabOnboardingRemoteDataSource>(
    () => LabOnboardingRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<LabOnboardingRepository>(
    () => LabOnboardingRepositoryImpl(
      remoteDataSource: sl<LabOnboardingRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<LabOnboardingUseCases>(
    () => LabOnboardingUseCases(repository: sl<LabOnboardingRepository>()),
  );

  sl.registerFactory<LabOnboardingProvider>(
    () => LabOnboardingProvider(
      useCases: sl<LabOnboardingUseCases>(),
      taxonomyUseCases: sl<TaxonomyUseCases>(),
    ),
  );

  sl.registerFactory<LabsListProvider>(
    () => LabsListProvider(useCases: sl<LabOnboardingUseCases>()),
  );

  sl.registerFactory<LabDetailProvider>(
    () => LabDetailProvider(useCases: sl<LabOnboardingUseCases>()),
  );
}
