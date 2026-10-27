import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/pet_remote_data_source.dart';
import '../data/repositories/pet_repository_impl.dart';
import '../domain/repositories/pet_repository.dart';
import '../domain/usecases/get_pets_by_parent_id_usecase.dart';
import '../presentation/providers/pets_provider.dart';

void initPetsDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<PetRemoteDataSource>(
    () => PetRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(remoteDataSource: sl<PetRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetPetsByParentIdUseCase>(
    () => GetPetsByParentIdUseCase(repository: sl<PetRepository>()),
  );

  sl.registerLazySingleton<PetUseCases>(
    () => PetUseCases(repository: sl<PetRepository>()),
  );

  sl.registerFactory<PetsProvider>(
    () => PetsProvider(getPetsByParentIdUseCase: sl<GetPetsByParentIdUseCase>()),
  );
}
