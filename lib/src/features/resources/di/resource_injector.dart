import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/resource_remote_data_source.dart';
import '../data/repositories/resource_repository_impl.dart';
import '../domain/repositories/resource_repository.dart';
import '../domain/usecases/resource_usecases.dart';
import '../presentation/providers/resource_provider.dart';

void initResourceDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<ResourceRemoteDataSource>(
    () => ResourceRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<ResourceRepository>(
    () => ResourceRepositoryImpl(
      remoteDataSource: sl<ResourceRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ResourceUseCases>(
    () => ResourceUseCases(repository: sl<ResourceRepository>()),
  );

  sl.registerFactory<ResourceProvider>(
    () => ResourceProvider(useCases: sl<ResourceUseCases>()),
  );
}
