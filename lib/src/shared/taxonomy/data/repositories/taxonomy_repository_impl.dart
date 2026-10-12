import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/pet_category_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/speciality_entity.dart';
import '../../domain/repositories/taxonomy_repository.dart';
import '../data_sources/taxonomy_remote_data_source.dart';
import '../models/pet_category_model.dart';
import '../models/service_model.dart';
import '../models/speciality_model.dart';

class TaxonomyRepositoryImpl implements TaxonomyRepository {
  final TaxonomyRemoteDataSource remoteDataSource;

  // In-memory single-source caches
  List<SpecialityEntity>? _cachedSpecialities;
  final Map<String, List<ServiceEntity>> _cachedServicesBySpeciality = {};
  List<ServiceEntity>? _cachedAllServices;
  List<PetCategoryEntity>? _cachedPetCategories;

  TaxonomyRepositoryImpl({required this.remoteDataSource});

  List<dynamic> _extractList(dynamic body) {
    if (body is List) return body;
    if (body is Map<String, dynamic>) {
      final data = body['data'];
      if (data is List) return data;
      if (data is Map<String, dynamic>) {
        if (data['docs'] is List) return data['docs'] as List;
        if (data['categories'] is List) return data['categories'] as List;
        if (data['services'] is List) return data['services'] as List;
        if (data['specialities'] is List) return data['specialities'] as List;
      }
      if (body['docs'] is List) return body['docs'] as List;
      if (body['categories'] is List) return body['categories'] as List;
      if (body['services'] is List) return body['services'] as List;
      if (body['specialities'] is List) return body['specialities'] as List;
    }
    return [];
  }

  @override
  Future<List<SpecialityEntity>> getSpecialities({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedSpecialities != null && _cachedSpecialities!.isNotEmpty) {
      return _cachedSpecialities!;
    }

    final Response response = await remoteDataSource.getSpecialities();
    final List<dynamic> rawList = _extractList(response.body);

    final result = rawList
        .map<SpecialityEntity>((e) =>
            SpecialityModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();

    _cachedSpecialities = result;
    return result;
  }

  @override
  Future<List<ServiceEntity>> getServices({
    String? specialityObjectId,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      if (specialityObjectId != null && _cachedServicesBySpeciality.containsKey(specialityObjectId)) {
        return _cachedServicesBySpeciality[specialityObjectId]!;
      }
      if (specialityObjectId == null && _cachedAllServices != null) {
        return _cachedAllServices!;
      }
    }

    final Response response = await remoteDataSource.getServices(
      specialityObjectId: specialityObjectId,
    );
    final List<dynamic> rawList = _extractList(response.body);

    final result = rawList
        .map<ServiceEntity>((e) =>
            ServiceModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();

    if (specialityObjectId != null) {
      _cachedServicesBySpeciality[specialityObjectId] = result;
    } else {
      _cachedAllServices = result;
    }

    return result;
  }

  @override
  Future<List<PetCategoryEntity>> getPetCategories({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedPetCategories != null && _cachedPetCategories!.isNotEmpty) {
      return _cachedPetCategories!;
    }

    final Response response = await remoteDataSource.getPetCategories();
    final List<dynamic> rawList = _extractList(response.body);

    final result = rawList
        .map<PetCategoryEntity>((e) =>
            PetCategoryModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();

    _cachedPetCategories = result;
    return result;
  }
}
