import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class AssignmentRequestsRemoteDataSource {
  Future<Response> getAssignmentRequests(Map<String, dynamic> queryParams);
  Future<Response> updateRequestStatus(String id, Map<String, dynamic> payload);
}

class AssignmentRequestsRemoteDataSourceImpl
    implements AssignmentRequestsRemoteDataSource {
  final ApiServices apiServices;

  const AssignmentRequestsRemoteDataSourceImpl({required this.apiServices});

  String get _baseUri =>
      '${ApiEndpoints.apiUrl}${ApiEndpoints.assignInfluencerRequest}';

  @override
  Future<Response> getAssignmentRequests(Map<String, dynamic> queryParams) {
    final sanitized = <String, String>{};
    queryParams.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        sanitized[key] = value.toString().trim();
      }
    });

    final uri = Uri.parse(_baseUri)
        .replace(queryParameters: sanitized.isEmpty ? null : sanitized)
        .toString();

    return apiServices.getData(uri);
  }

  @override
  Future<Response> updateRequestStatus(
    String id,
    Map<String, dynamic> payload,
  ) {
    return apiServices.patchData('$_baseUri/$id', payload);
  }
}

