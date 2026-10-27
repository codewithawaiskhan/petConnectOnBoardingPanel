import '../entities/pet_gallery_entity.dart';

abstract class PetGalleryRepository {
  Future<List<PetGalleryEntity>> getPetGalleryByUserId(String userId);
}
