import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/marketing_company_remote_data_source.dart';
import '../data/repositories/marketing_company_repository_impl.dart';
import '../domain/repositories/marketing_company_repository.dart';
import '../domain/usecases/marketing_company_usecases.dart';
import '../presentation/providers/marketing_company_list_provider.dart';

void initMarketingCompaniesDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<MarketingCompanyRemoteDataSource>(
    () => MarketingCompanyRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<MarketingCompanyRepository>(
    () => MarketingCompanyRepositoryImpl(
      remoteDataSource: sl<MarketingCompanyRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetMarketingCompaniesUseCase>(
    () => GetMarketingCompaniesUseCase(
      repository: sl<MarketingCompanyRepository>(),
    ),
  );

  sl.registerLazySingleton<CreateMarketingCompanyUseCase>(
    () => CreateMarketingCompanyUseCase(
      repository: sl<MarketingCompanyRepository>(),
    ),
  );

  sl.registerLazySingleton<UpdateMarketingCompanyUseCase>(
    () => UpdateMarketingCompanyUseCase(
      repository: sl<MarketingCompanyRepository>(),
    ),
  );

  sl.registerLazySingleton<DeleteMarketingCompanyUseCase>(
    () => DeleteMarketingCompanyUseCase(
      repository: sl<MarketingCompanyRepository>(),
    ),
  );

  sl.registerFactory<MarketingCompanyListProvider>(
    () => MarketingCompanyListProvider(
      getMarketingCompaniesUseCase: sl<GetMarketingCompaniesUseCase>(),
      createMarketingCompanyUseCase: sl<CreateMarketingCompanyUseCase>(),
      updateMarketingCompanyUseCase: sl<UpdateMarketingCompanyUseCase>(),
      deleteMarketingCompanyUseCase: sl<DeleteMarketingCompanyUseCase>(),
    ),
  );
}

