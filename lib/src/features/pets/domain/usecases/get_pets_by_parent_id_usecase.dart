import '../entities/pet_entity.dart';
import '../repositories/pet_repository.dart';

class GetPetsByParentIdUseCase {
  final PetRepository repository;

  const GetPetsByParentIdUseCase({required this.repository});

  Future<List<PetEntity>> call(String parentId) {
    return repository.getPetsByParentId(parentId);
  }
}

class PetUseCases {
  final PetRepository repository;

  const PetUseCases({required this.repository});

  Future<List<PetEntity>> getPetsByParentId(String parentId) {
    return repository.getPetsByParentId(parentId);
  }
}
