import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/my_team_remote_data_source.dart';
import '../data/repositories/my_team_repository_impl.dart';
import '../domain/repositories/my_team_repository.dart';
import '../domain/usecases/my_team_usecases.dart';
import '../presentation/providers/my_team_provider.dart';

void initMyTeamDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<MyTeamRemoteDataSource>(
    () => MyTeamRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<MyTeamRepository>(
    () => MyTeamRepositoryImpl(
      remoteDataSource: sl<MyTeamRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetMyInfluencersUseCase>(
    () => GetMyInfluencersUseCase(repository: sl<MyTeamRepository>()),
  );

  sl.registerLazySingleton<SearchUserByReferralCodeUseCase>(
    () => SearchUserByReferralCodeUseCase(repository: sl<MyTeamRepository>()),
  );

  sl.registerLazySingleton<CreateAssignInfluencerRequestUseCase>(
    () => CreateAssignInfluencerRequestUseCase(
      repository: sl<MyTeamRepository>(),
    ),
  );

  sl.registerFactory<MyTeamProvider>(
    () => MyTeamProvider(
      getMyInfluencersUseCase: sl<GetMyInfluencersUseCase>(),
      searchUserByReferralCodeUseCase: sl<SearchUserByReferralCodeUseCase>(),
      createAssignInfluencerRequestUseCase:
          sl<CreateAssignInfluencerRequestUseCase>(),
    ),
  );
}

