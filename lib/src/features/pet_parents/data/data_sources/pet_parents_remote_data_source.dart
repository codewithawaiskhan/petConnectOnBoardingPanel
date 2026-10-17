import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';
import '../../../../app/config/api_endpoints.dart';

abstract class PetParentsRemoteDataSource {
  Future<Response> getPetParents({
    int page = 1,
    int pageSize = 10,
    String? keyword,
    String? from,
    String? to,
    String? countryCode,
  });

  Future<Response> getPetParentDetail(String id);

  Future<Response> updatePetParent(String id, Map<String, dynamic> body);

  Future<Response> updatePetParentPassword(String id, Map<String, dynamic> body);

  Future<Response> deletePetParent(String id);
}

class PetParentsRemoteDataSourceImpl implements PetParentsRemoteDataSource {
  final ApiServices apiServices;

  const PetParentsRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getPetParents({
    int page = 1,
    int pageSize = 10,
    String? keyword,
    String? from,
    String? to,
    String? countryCode,
  }) {
    final queryParams = <String, String>{
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    if (keyword != null && keyword.trim().isNotEmpty) {
      queryParams['keyword'] = keyword.trim();
    }
    if (from != null && from.trim().isNotEmpty) {
      queryParams['from'] = from.trim();
    }
    if (to != null && to.trim().isNotEmpty) {
      queryParams['to'] = to.trim();
    }
    if (countryCode != null && countryCode.trim().isNotEmpty) {
      final countryVal = countryCode.trim();
      queryParams['countryCode'] = countryVal;
      queryParams['countryName'] = countryVal;
      queryParams['country'] = countryVal;
    }

    final uri = Uri.parse(
      ApiEndpoints.petParents,
    ).replace(queryParameters: queryParams).toString();

    return apiServices.getData(uri);
  }

  @override
  Future<Response> getPetParentDetail(String id) {
    return apiServices.getData(ApiEndpoints.petParentDetail(id));
  }

  @override
  Future<Response> updatePetParent(String id, Map<String, dynamic> body) {
    return apiServices.patchData(ApiEndpoints.updatePetParent(id), body);
  }

  @override
  Future<Response> updatePetParentPassword(String id, Map<String, dynamic> body) {
    return apiServices.patchData(ApiEndpoints.updatePetParentPassword(id), body);
  }

  @override
  Future<Response> deletePetParent(String id) {
    return apiServices.deleteData(ApiEndpoints.petParentDetail(id));
  }
}
