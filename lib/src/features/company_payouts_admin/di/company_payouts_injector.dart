import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/company_payouts_remote_data_source.dart';
import '../data/repositories/company_payouts_repository_impl.dart';
import '../domain/repositories/company_payouts_repository.dart';
import '../domain/usecases/company_payouts_usecases.dart';
import '../presentation/providers/company_payouts_provider.dart';

void initCompanyPayoutsDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<CompanyPayoutsRemoteDataSource>(
    () => CompanyPayoutsRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<CompanyPayoutsRepository>(
    () => CompanyPayoutsRepositoryImpl(
      remoteDataSource: sl<CompanyPayoutsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<CompanyPayoutsUseCases>(
    () => CompanyPayoutsUseCases(
      repository: sl<CompanyPayoutsRepository>(),
    ),
  );

  sl.registerFactory<CompanyPayoutsProvider>(
    () => CompanyPayoutsProvider(
      useCases: sl<CompanyPayoutsUseCases>(),
    ),
  );
}

