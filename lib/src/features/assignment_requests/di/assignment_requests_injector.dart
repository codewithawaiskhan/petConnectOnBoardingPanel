import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/assignment_requests_remote_data_source.dart';
import '../data/repositories/assignment_requests_repository_impl.dart';
import '../domain/repositories/assignment_requests_repository.dart';
import '../domain/usecases/assignment_requests_usecases.dart';
import '../presentation/providers/assignment_requests_provider.dart';

void initAssignmentRequestsDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<AssignmentRequestsRemoteDataSource>(
    () => AssignmentRequestsRemoteDataSourceImpl(
      apiServices: sl<ApiServices>(),
    ),
  );

  sl.registerLazySingleton<AssignmentRequestsRepository>(
    () => AssignmentRequestsRepositoryImpl(
      remoteDataSource: sl<AssignmentRequestsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetAssignmentRequestsUseCase>(
    () => GetAssignmentRequestsUseCase(
      repository: sl<AssignmentRequestsRepository>(),
    ),
  );

  sl.registerLazySingleton<UpdateAssignmentRequestStatusUseCase>(
    () => UpdateAssignmentRequestStatusUseCase(
      repository: sl<AssignmentRequestsRepository>(),
    ),
  );

  sl.registerFactory<AssignmentRequestsProvider>(
    () => AssignmentRequestsProvider(
      getAssignmentRequestsUseCase: sl<GetAssignmentRequestsUseCase>(),
      updateAssignmentRequestStatusUseCase:
          sl<UpdateAssignmentRequestStatusUseCase>(),
    ),
  );
}

