import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/pet_parents_remote_data_source.dart';
import '../data/repositories/pet_parents_repository_impl.dart';
import '../domain/repositories/pet_parents_repository.dart';
import '../domain/usecases/pet_parents_usecases.dart';
import '../presentation/providers/pet_parent_detail_provider.dart';
import '../presentation/providers/pet_parents_list_provider.dart';

void initPetParentsDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<PetParentsRemoteDataSource>(
    () => PetParentsRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<PetParentsRepository>(
    () => PetParentsRepositoryImpl(
      remoteDataSource: sl<PetParentsRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<PetParentsUseCases>(
    () => PetParentsUseCases(repository: sl<PetParentsRepository>()),
  );

  sl.registerFactory<PetParentsListProvider>(
    () => PetParentsListProvider(useCases: sl<PetParentsUseCases>()),
  );

  sl.registerFactory<PetParentDetailProvider>(
    () => PetParentDetailProvider(useCases: sl<PetParentsUseCases>()),
  );
}
