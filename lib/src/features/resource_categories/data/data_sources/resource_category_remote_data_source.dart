import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class ResourceCategoryRemoteDataSource {
  Future<Response> getCategories({String sortBy = "createdAt_ascending"});
  Future<Response> addCategory(Map<String, dynamic> body);
  Future<Response> updateCategory(String id, Map<String, dynamic> body);
  Future<Response> deleteCategory(String id);
}

class ResourceCategoryRemoteDataSourceImpl
    implements ResourceCategoryRemoteDataSource {
  final ApiServices apiServices;

  const ResourceCategoryRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getCategories({String sortBy = "createdAt_ascending"}) {
    return apiServices.getData(ApiEndpoints.getPostCategories);
  }

  @override
  Future<Response> addCategory(Map<String, dynamic> body) {
    return apiServices.postData(ApiEndpoints.postCategories, body);
  }

  @override
  Future<Response> updateCategory(String id, Map<String, dynamic> body) {
    return apiServices.patchData(ApiEndpoints.updatePostCategory(id), body);
  }

  @override
  Future<Response> deleteCategory(String id) {
    return apiServices.deleteData(ApiEndpoints.deletePostCategory(id));
  }
}
