import '../entities/pet_parent_entity.dart';

abstract class PetParentsRepository {
  Future<PetParentsListResponseEntity> getPetParents({
    int page = 1,
    int pageSize = 10,
    String? keyword,
    String? from,
    String? to,
    String? countryCode,
  });

  Future<PetParentDetailResponseEntity> getPetParentDetail(String id);

  Future<PetParentDetailResponseEntity> updatePetParent(
    String id,
    UpdatePetParentEntity entity,
  );

  Future<PetParentActionResponseEntity> updatePetParentPassword(
    String id,
    UpdatePetParentPasswordEntity entity,
  );

  Future<PetParentActionResponseEntity> deletePetParent(String id);
}
