import '../entities/pet_gallery_entity.dart';
import '../repositories/pet_gallery_repository.dart';

class PetGalleryUseCases {
  final PetGalleryRepository repository;

  PetGalleryUseCases({required this.repository});

  Future<List<PetGalleryEntity>> getPetGalleryByUserId(String userId) {
    return repository.getPetGalleryByUserId(userId);
  }
}

class GetPetGalleryByUserIdUseCase {
  final PetGalleryRepository repository;

  GetPetGalleryByUserIdUseCase(this.repository);

  Future<List<PetGalleryEntity>> call(String userId) {
    return repository.getPetGalleryByUserId(userId);
  }
}
