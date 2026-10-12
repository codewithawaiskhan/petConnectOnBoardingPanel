import '../entities/pet_category_entity.dart';
import '../entities/service_entity.dart';
import '../entities/speciality_entity.dart';
import '../repositories/taxonomy_repository.dart';

class TaxonomyUseCases {
  final TaxonomyRepository repository;

  const TaxonomyUseCases({required this.repository});

  Future<List<SpecialityEntity>> getSpecialities({bool forceRefresh = false}) async {
    return await repository.getSpecialities(forceRefresh: forceRefresh);
  }

  Future<List<ServiceEntity>> getServices({
    String? specialityObjectId,
    bool forceRefresh = false,
  }) async {
    return await repository.getServices(
      specialityObjectId: specialityObjectId,
      forceRefresh: forceRefresh,
    );
  }

  Future<List<PetCategoryEntity>> getPetCategories({bool forceRefresh = false}) async {
    return await repository.getPetCategories(forceRefresh: forceRefresh);
  }
}
