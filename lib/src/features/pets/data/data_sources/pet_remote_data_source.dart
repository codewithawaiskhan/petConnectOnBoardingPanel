import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class PetRemoteDataSource {
  Future<Response> getPetsByParentId(String parentId);
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final ApiServices apiServices;

  const PetRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getPetsByParentId(String parentId) {
    return apiServices.getData(ApiEndpoints.petsByParent(parentId));
  }
}
