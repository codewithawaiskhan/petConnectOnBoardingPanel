import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class CampaignRemoteDataSource {
  Future<Response> getCampaigns({
    int page = 1,
    int pageSize = 10,
    String? from,
    String? to,
    String? sortBy,
    String? keyword,
  });

  Future<Response> getCampaignDetail(String id);
  Future<Response> addCampaign(Map<String, dynamic> body);
  Future<Response> updateCampaign(String id, Map<String, dynamic> body);
  Future<Response> deleteCampaign(String id);
}

class CampaignRemoteDataSourceImpl implements CampaignRemoteDataSource {
  final ApiServices apiServices;

  const CampaignRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getCampaigns({
    int page = 1,
    int pageSize = 10,
    String? from,
    String? to,
    String? sortBy,
    String? keyword,
  }) {
    final queryParams = <String, String>{
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    if (from != null && from.trim().isNotEmpty) {
      queryParams['from'] = from.trim();
    }
    if (to != null && to.trim().isNotEmpty) {
      queryParams['to'] = to.trim();
    }
    if (sortBy != null && sortBy.trim().isNotEmpty) {
      queryParams['sortBy'] = sortBy.trim();
    }
    if (keyword != null && keyword.trim().isNotEmpty) {
      queryParams['keyword'] = keyword.trim();
    }

    final uri = Uri.parse(ApiEndpoints.campaigns)
        .replace(queryParameters: queryParams)
        .toString();

    return apiServices.getData(uri);
  }

  @override
  Future<Response> getCampaignDetail(String id) {
    return apiServices.getData(ApiEndpoints.campaignDetail(id));
  }

  @override
  Future<Response> addCampaign(Map<String, dynamic> body) {
    return apiServices.postData(ApiEndpoints.campaigns, body);
  }

  @override
  Future<Response> updateCampaign(String id, Map<String, dynamic> body) {
    return apiServices.patchData(ApiEndpoints.updateCampaign(id), body);
  }

  @override
  Future<Response> deleteCampaign(String id) {
    return apiServices.deleteData(ApiEndpoints.deleteCampaign(id));
  }
}
