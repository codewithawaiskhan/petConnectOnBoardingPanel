import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/dashboard_remote_data_source.dart';
import '../data/repositories/dashboard_repository_impl.dart';
import '../domain/repositories/dashboard_repository.dart';
import '../domain/usecases/dashboard_usecases.dart';
import '../presentation/providers/dashboard_provider.dart';

void initDashboardDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl<DashboardRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<DashboardUseCases>(
    () => DashboardUseCases(repository: sl<DashboardRepository>()),
  );

  sl.registerFactory<DashboardProvider>(
    () => DashboardProvider(useCases: sl<DashboardUseCases>()),
  );
}
