import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class MyTeamRemoteDataSource {
  Future<Response> getMyInfluencers(Map<String, dynamic> queryParams);
  Future<Response> searchUserByReferralCode(String code);
  Future<Response> requestInfluencerAssignment(Map<String, dynamic> payload);
}

class MyTeamRemoteDataSourceImpl implements MyTeamRemoteDataSource {
  final ApiServices apiServices;

  const MyTeamRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getMyInfluencers(Map<String, dynamic> queryParams) {
    final sanitized = <String, String>{};
    queryParams.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        sanitized[key] = value.toString().trim();
      }
    });

    final baseUri = '${ApiEndpoints.apiUrl}${ApiEndpoints.myInfluencers}';
    final uri = Uri.parse(baseUri)
        .replace(queryParameters: sanitized.isEmpty ? null : sanitized)
        .toString();

    return apiServices.getData(uri);
  }

  @override
  Future<Response> searchUserByReferralCode(String code) {
    final uri =
        '${ApiEndpoints.apiUrl}${ApiEndpoints.userByReferralCode(code.trim())}';
    return apiServices.getData(uri);
  }

  @override
  Future<Response> requestInfluencerAssignment(Map<String, dynamic> payload) {
    final uri =
        '${ApiEndpoints.apiUrl}${ApiEndpoints.assignInfluencerRequest}';
    return apiServices.postData(uri, payload);
  }
}

