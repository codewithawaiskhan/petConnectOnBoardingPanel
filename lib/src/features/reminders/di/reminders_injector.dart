import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/reminders_remote_data_source.dart';
import '../data/repositories/reminders_repository_impl.dart';
import '../domain/repositories/reminders_repository.dart';
import '../domain/usecases/reminders_usecases.dart';
import '../presentation/providers/reminders_provider.dart';

void initRemindersDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<RemindersRemoteDataSource>(
    () => RemindersRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<RemindersRepository>(
    () => RemindersRepositoryImpl(
      remoteDataSource: sl<RemindersRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetRemindersByUserIdUseCase>(
    () => GetRemindersByUserIdUseCase(
      repository: sl<RemindersRepository>(),
    ),
  );

  sl.registerLazySingleton<RemindersUseCases>(
    () => RemindersUseCases(
      repository: sl<RemindersRepository>(),
    ),
  );

  sl.registerFactory<RemindersProvider>(
    () => RemindersProvider(useCases: sl<RemindersUseCases>()),
  );
}
