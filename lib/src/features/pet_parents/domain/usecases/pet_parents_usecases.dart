import '../entities/pet_parent_entity.dart';
import '../repositories/pet_parents_repository.dart';

class PetParentsUseCases {
  final PetParentsRepository repository;

  const PetParentsUseCases({required this.repository});

  Future<PetParentsListResponseEntity> getPetParents({
    int page = 1,
    int pageSize = 10,
    String? keyword,
  }) {
    return repository.getPetParents(
      page: page,
      pageSize: pageSize,
      keyword: keyword,
    );
  }

  Future<PetParentDetailResponseEntity> getPetParentDetail(String id) {
    return repository.getPetParentDetail(id);
  }
}
