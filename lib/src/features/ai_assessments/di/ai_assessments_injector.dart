import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/ai_assessments_remote_data_source.dart';
import '../data/repositories/ai_assessments_repository_impl.dart';
import '../domain/repositories/ai_assessments_repository.dart';
import '../domain/usecases/ai_assessments_usecases.dart';
import '../presentation/providers/ai_assessments_provider.dart';

void initAiAssessmentsDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<AiAssessmentsRemoteDataSource>(
    () => AiAssessmentsRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<AiAssessmentsRepository>(
    () => AiAssessmentsRepositoryImpl(
      remoteDataSource: sl<AiAssessmentsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetAiAssessmentsByUserIdUseCase>(
    () => GetAiAssessmentsByUserIdUseCase(
      repository: sl<AiAssessmentsRepository>(),
    ),
  );

  sl.registerLazySingleton<AiAssessmentsUseCases>(
    () => AiAssessmentsUseCases(
      repository: sl<AiAssessmentsRepository>(),
    ),
  );

  sl.registerFactory<AiAssessmentsProvider>(
    () => AiAssessmentsProvider(useCases: sl<AiAssessmentsUseCases>()),
  );
}
