import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';
import '../../../../app/config/api_endpoints.dart';

abstract class PetParentsRemoteDataSource {
  Future<Response> getPetParents({
    int page = 1,
    int pageSize = 10,
    String? keyword,
  });

  Future<Response> getPetParentDetail(String id);
}

class PetParentsRemoteDataSourceImpl implements PetParentsRemoteDataSource {
  final ApiServices apiServices;

  const PetParentsRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getPetParents({
    int page = 1,
    int pageSize = 10,
    String? keyword,
  }) {
    final queryParams = <String, String>{
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    if (keyword != null && keyword.trim().isNotEmpty) {
      queryParams['keyword'] = keyword.trim();
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
}
