import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/withdrawal_remote_data_source.dart';
import '../data/repositories/withdrawal_repository_impl.dart';
import '../domain/repositories/withdrawal_repository.dart';
import '../domain/usecases/withdrawal_usecases.dart';
import '../presentation/providers/withdrawal_list_provider.dart';

void initWithdrawalDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<WithdrawalRemoteDataSource>(
    () => WithdrawalRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<WithdrawalRepository>(
    () => WithdrawalRepositoryImpl(
      remoteDataSource: sl<WithdrawalRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetWithdrawalRequestsUseCase>(
    () => GetWithdrawalRequestsUseCase(repository: sl<WithdrawalRepository>()),
  );

  sl.registerLazySingleton<UpdateWithdrawalStatusUseCase>(
    () => UpdateWithdrawalStatusUseCase(
      repository: sl<WithdrawalRepository>(),
    ),
  );

  sl.registerFactory<WithdrawalListProvider>(
    () => WithdrawalListProvider(
      getWithdrawalRequestsUseCase: sl<GetWithdrawalRequestsUseCase>(),
      updateWithdrawalStatusUseCase: sl<UpdateWithdrawalStatusUseCase>(),
    ),
  );
}
