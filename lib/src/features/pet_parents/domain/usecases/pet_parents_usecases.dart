import '../entities/pet_parent_entity.dart';
import '../repositories/pet_parents_repository.dart';

class PetParentsUseCases {
  final PetParentsRepository repository;

  const PetParentsUseCases({required this.repository});

  Future<PetParentsListResponseEntity> getPetParents({
    int page = 1,
    int pageSize = 10,
    String? keyword,
    String? from,
    String? to,
    String? countryCode,
  }) {
    return repository.getPetParents(
      page: page,
      pageSize: pageSize,
      keyword: keyword,
      from: from,
      to: to,
      countryCode: countryCode,
    );
  }

  Future<PetParentDetailResponseEntity> getPetParentDetail(String id) {
    return repository.getPetParentDetail(id);
  }

  Future<PetParentDetailResponseEntity> updatePetParent(
    String id,
    UpdatePetParentEntity entity,
  ) {
    return repository.updatePetParent(id, entity);
  }

  Future<PetParentActionResponseEntity> updatePetParentPassword(
    String id,
    UpdatePetParentPasswordEntity entity,
  ) {
    return repository.updatePetParentPassword(id, entity);
  }

  Future<PetParentActionResponseEntity> deletePetParent(String id) {
    return repository.deletePetParent(id);
  }
}
