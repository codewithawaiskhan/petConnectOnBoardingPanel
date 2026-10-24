import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class ResourceRemoteDataSource {
  Future<Response> getResources({
    int page = 1,
    int pageSize = 10,
    String? postCategory,
    String? keyword,
    String? sortBy,
  });

  Future<Response> getResourceDetail(String id);
  Future<Response> addResource(Map<String, dynamic> body);
  Future<Response> updateResource(String id, Map<String, dynamic> body);
  Future<Response> deleteResource(String id);
}

class ResourceRemoteDataSourceImpl implements ResourceRemoteDataSource {
  final ApiServices apiServices;

  const ResourceRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getResources({
    int page = 1,
    int pageSize = 10,
    String? postCategory,
    String? keyword,
    String? sortBy,
  }) {
    final queryParams = <String, String>{
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    if (postCategory != null && postCategory.trim().isNotEmpty) {
      queryParams['postCategory'] = postCategory.trim();
    }
    if (keyword != null && keyword.trim().isNotEmpty) {
      queryParams['keyword'] = keyword.trim();
    }
    if (sortBy != null && sortBy.trim().isNotEmpty) {
      queryParams['sortBy'] = sortBy.trim();
    }

    final uri = Uri.parse(ApiEndpoints.posts)
        .replace(queryParameters: queryParams)
        .toString();

    return apiServices.getData(uri);
  }

  @override
  Future<Response> getResourceDetail(String id) {
    return apiServices.getData(ApiEndpoints.postDetail(id));
  }

  @override
  Future<Response> addResource(Map<String, dynamic> body) {
    return apiServices.postData(ApiEndpoints.posts, body);
  }

  @override
  Future<Response> updateResource(String id, Map<String, dynamic> body) {
    return apiServices.patchData(ApiEndpoints.updatePost(id), body);
  }

  @override
  Future<Response> deleteResource(String id) {
    return apiServices.deleteData(ApiEndpoints.deletePost(id));
  }
}
