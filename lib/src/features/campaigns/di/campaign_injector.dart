import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/campaign_remote_data_source.dart';
import '../data/repositories/campaign_repository_impl.dart';
import '../domain/repositories/campaign_repository.dart';
import '../domain/usecases/campaign_usecases.dart';
import '../presentation/providers/campaign_provider.dart';

void initCampaignDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<CampaignRemoteDataSource>(
    () => CampaignRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<CampaignRepository>(
    () => CampaignRepositoryImpl(
      remoteDataSource: sl<CampaignRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<CampaignUseCases>(
    () => CampaignUseCases(repository: sl<CampaignRepository>()),
  );

  sl.registerFactory<CampaignProvider>(
    () => CampaignProvider(useCases: sl<CampaignUseCases>()),
  );
}
