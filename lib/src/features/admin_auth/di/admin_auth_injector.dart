import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/admin_auth_local_data_source.dart';
import '../data/data_sources/admin_auth_remote_data_source.dart';
import '../data/repositories/admin_auth_repository_impl.dart';
import '../domain/repositories/admin_auth_repository.dart';
import '../domain/usecases/admin_auth_usecases.dart';
import '../presentation/providers/admin_auth_provider.dart';

void initAdminAuthDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<AdminAuthRemoteDataSource>(
    () => AdminAuthRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );
  sl.registerLazySingleton<AdminAuthLocalDataSource>(
    () => AdminAuthLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  sl.registerLazySingleton<AdminAuthRepository>(
    () => AdminAuthRepositoryImpl(
      remoteDataSource: sl<AdminAuthRemoteDataSource>(),
      localDataSource: sl<AdminAuthLocalDataSource>(),
      apiServices: sl<ApiServices>(),
    ),
  );

  sl.registerLazySingleton<AdminAuthUseCases>(
    () => AdminAuthUseCases(repository: sl<AdminAuthRepository>()),
  );

  sl.registerLazySingleton<AdminAuthProvider>(
    () => AdminAuthProvider(useCases: sl<AdminAuthUseCases>()),
  );
}
