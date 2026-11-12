import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/company_dashboard_remote_data_source.dart';
import '../data/repositories/company_dashboard_repository_impl.dart';
import '../domain/repositories/company_dashboard_repository.dart';
import '../domain/usecases/company_dashboard_usecases.dart';
import '../presentation/providers/company_dashboard_provider.dart';

void initCompanyDashboardDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<CompanyDashboardRemoteDataSource>(
    () => CompanyDashboardRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<CompanyDashboardRepository>(
    () => CompanyDashboardRepositoryImpl(
      remoteDataSource: sl<CompanyDashboardRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetMyCompanyProfileUseCase>(
    () => GetMyCompanyProfileUseCase(
      repository: sl<CompanyDashboardRepository>(),
    ),
  );

  sl.registerLazySingleton<GetMyReferralStatsUseCase>(
    () => GetMyReferralStatsUseCase(
      repository: sl<CompanyDashboardRepository>(),
    ),
  );

  sl.registerFactory<CompanyDashboardProvider>(
    () => CompanyDashboardProvider(
      getMyCompanyProfileUseCase: sl<GetMyCompanyProfileUseCase>(),
      getMyReferralStatsUseCase: sl<GetMyReferralStatsUseCase>(),
    ),
  );
}

