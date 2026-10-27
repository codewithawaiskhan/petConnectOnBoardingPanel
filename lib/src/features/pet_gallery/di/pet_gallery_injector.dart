import 'package:get_it/get_it.dart';
import '../../../core/network/api_services.dart';
import '../data/data_sources/pet_gallery_remote_data_source.dart';
import '../data/repositories/pet_gallery_repository_impl.dart';
import '../domain/repositories/pet_gallery_repository.dart';
import '../domain/usecases/pet_gallery_usecases.dart';
import '../presentation/providers/pet_gallery_provider.dart';

void initPetGalleryDependencies() {
  final sl = GetIt.instance;

  sl.registerLazySingleton<PetGalleryRemoteDataSource>(
    () => PetGalleryRemoteDataSourceImpl(apiServices: sl<ApiServices>()),
  );

  sl.registerLazySingleton<PetGalleryRepository>(
    () => PetGalleryRepositoryImpl(
      remoteDataSource: sl<PetGalleryRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetPetGalleryByUserIdUseCase>(
    () => GetPetGalleryByUserIdUseCase(
      sl<PetGalleryRepository>(),
    ),
  );

  sl.registerLazySingleton<PetGalleryUseCases>(
    () => PetGalleryUseCases(
      repository: sl<PetGalleryRepository>(),
    ),
  );

  sl.registerFactory<PetGalleryProvider>(
    () => PetGalleryProvider(useCases: sl<PetGalleryUseCases>()),
  );
}
