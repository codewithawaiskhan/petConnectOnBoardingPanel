import '../entities/pet_category_entity.dart';
import '../entities/service_entity.dart';
import '../entities/speciality_entity.dart';

abstract class TaxonomyRepository {
  Future<List<SpecialityEntity>> getSpecialities({bool forceRefresh = false});
  Future<List<ServiceEntity>> getServices({String? specialityObjectId, bool forceRefresh = false});
  Future<List<PetCategoryEntity>> getPetCategories({bool forceRefresh = false});
}
