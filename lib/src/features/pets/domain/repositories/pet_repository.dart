import '../entities/pet_entity.dart';

abstract class PetRepository {
  Future<List<PetEntity>> getPetsByParentId(String parentId);
}
