import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/admin_settings_remote_data_source.dart';
import '../data/repositories/admin_settings_repository_impl.dart';
import '../domain/repositories/admin_settings_repository.dart';
import '../domain/usecases/admin_settings_usecases.dart';
import '../presentation/providers/admin_settings_provider.dart';

void initAdminSettingsInjector() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<AdminSettingsRemoteDataSource>(
    () => AdminSettingsRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<AdminSettingsRepository>(
    () => AdminSettingsRepositoryImpl(
      remoteDataSource: sl<AdminSettingsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<AdminSettingsUseCases>(
    () => AdminSettingsUseCases(repository: sl<AdminSettingsRepository>()),
  );

  sl.registerLazySingleton<GetSettingsUseCase>(
    () => GetSettingsUseCase(sl<AdminSettingsUseCases>()),
  );

  sl.registerLazySingleton<UpdateSettingsUseCase>(
    () => UpdateSettingsUseCase(sl<AdminSettingsUseCases>()),
  );

  sl.registerFactory<AdminSettingsProvider>(
    () => AdminSettingsProvider(useCases: sl<AdminSettingsUseCases>()),
  );
}
