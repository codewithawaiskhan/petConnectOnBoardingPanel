import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class TaxonomyRemoteDataSource {
  Future<Response> getSpecialities();
  Future<Response> getServices({String? specialityObjectId});
  Future<Response> getPetCategories();
}

class TaxonomyRemoteDataSourceImpl implements TaxonomyRemoteDataSource {
  final ApiServices apiServices;

  TaxonomyRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getSpecialities() async {
    return await apiServices.getData(ApiEndpoints.specialities);
  }

  @override
  Future<Response> getServices({String? specialityObjectId}) async {
    final endpoint = (specialityObjectId != null && specialityObjectId.isNotEmpty)
        ? '${ApiEndpoints.services}?specialityObjectId=$specialityObjectId'
        : ApiEndpoints.services;
    return await apiServices.getData(endpoint);
  }

  @override
  Future<Response> getPetCategories() async {
    return await apiServices.getData(ApiEndpoints.petCategories);
  }
}
