import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/company_redemptions_remote_data_source.dart';
import '../data/repositories/company_redemptions_repository_impl.dart';
import '../domain/repositories/company_redemptions_repository.dart';
import '../domain/usecases/company_redemptions_usecases.dart';
import '../presentation/providers/company_redemptions_provider.dart';

void initCompanyRedemptionsDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<CompanyRedemptionsRemoteDataSource>(
    () =>
        CompanyRedemptionsRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<CompanyRedemptionsRepository>(
    () => CompanyRedemptionsRepositoryImpl(
      remoteDataSource: sl<CompanyRedemptionsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetMyRedemptionsUseCase>(
    () => GetMyRedemptionsUseCase(
      repository: sl<CompanyRedemptionsRepository>(),
    ),
  );

  sl.registerLazySingleton<RequestPayPalRedemptionUseCase>(
    () => RequestPayPalRedemptionUseCase(
      repository: sl<CompanyRedemptionsRepository>(),
    ),
  );

  sl.registerLazySingleton<CompanyRedemptionsUseCases>(
    () => CompanyRedemptionsUseCases(
      repository: sl<CompanyRedemptionsRepository>(),
    ),
  );

  sl.registerFactory<CompanyRedemptionsProvider>(
    () => CompanyRedemptionsProvider(
      getMyRedemptionsUseCase: sl<GetMyRedemptionsUseCase>(),
      requestPayPalRedemptionUseCase: sl<RequestPayPalRedemptionUseCase>(),
    ),
  );
}

