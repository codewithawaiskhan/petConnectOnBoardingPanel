import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/company_wallet_remote_data_source.dart';
import '../data/repositories/company_wallet_repository_impl.dart';
import '../domain/repositories/company_wallet_repository.dart';
import '../domain/usecases/company_wallet_usecases.dart';
import '../presentation/providers/company_wallet_provider.dart';

void initCompanyWalletDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<CompanyWalletRemoteDataSource>(
    () => CompanyWalletRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<CompanyWalletRepository>(
    () => CompanyWalletRepositoryImpl(
      remoteDataSource: sl<CompanyWalletRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetMyReferralBalanceUseCase>(
    () => GetMyReferralBalanceUseCase(
      repository: sl<CompanyWalletRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMyCommissionLedgerUseCase>(
    () => GetMyCommissionLedgerUseCase(
      repository: sl<CompanyWalletRepository>(),
    ),
  );

  sl.registerLazySingleton<CompanyWalletUseCases>(
    () => CompanyWalletUseCases(
      repository: sl<CompanyWalletRepository>(),
    ),
  );

  sl.registerFactory<CompanyWalletProvider>(
    () => CompanyWalletProvider(
      getMyReferralBalanceUseCase: sl<GetMyReferralBalanceUseCase>(),
      getMyCommissionLedgerUseCase: sl<GetMyCommissionLedgerUseCase>(),
    ),
  );
}

