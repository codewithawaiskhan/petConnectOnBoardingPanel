import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/resource_category_remote_data_source.dart';
import '../data/repositories/resource_category_repository_impl.dart';
import '../domain/repositories/resource_category_repository.dart';
import '../domain/usecases/resource_category_usecases.dart';
import '../presentation/providers/resource_category_provider.dart';

void initResourceCategoriesDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<ResourceCategoryRemoteDataSource>(
    () => ResourceCategoryRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<ResourceCategoryRepository>(
    () => ResourceCategoryRepositoryImpl(
      remoteDataSource: sl<ResourceCategoryRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ResourceCategoryUseCases>(
    () => ResourceCategoryUseCases(
      repository: sl<ResourceCategoryRepository>(),
    ),
  );

  sl.registerFactory<ResourceCategoryProvider>(
    () => ResourceCategoryProvider(useCases: sl<ResourceCategoryUseCases>()),
  );
}
