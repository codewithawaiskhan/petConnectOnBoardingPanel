import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/medical_records_remote_data_source.dart';
import '../data/repositories/medical_records_repository_impl.dart';
import '../domain/repositories/medical_records_repository.dart';
import '../domain/usecases/medical_records_usecases.dart';
import '../presentation/providers/medical_records_provider.dart';

void initMedicalRecordsDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<MedicalRecordsRemoteDataSource>(
    () => MedicalRecordsRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<MedicalRecordsRepository>(
    () => MedicalRecordsRepositoryImpl(
      remoteDataSource: sl<MedicalRecordsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetMedicalRecordsByUserIdUseCase>(
    () => GetMedicalRecordsByUserIdUseCase(
      repository: sl<MedicalRecordsRepository>(),
    ),
  );

  sl.registerLazySingleton<MedicalRecordsUseCases>(
    () => MedicalRecordsUseCases(
      repository: sl<MedicalRecordsRepository>(),
    ),
  );

  sl.registerFactory<MedicalRecordsProvider>(
    () => MedicalRecordsProvider(useCases: sl<MedicalRecordsUseCases>()),
  );
}
