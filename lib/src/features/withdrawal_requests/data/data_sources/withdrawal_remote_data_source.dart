import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class WithdrawalRemoteDataSource {
  Future<Response> getWithdrawalRequests(Map<String, dynamic> queryParams);
  Future<Response> updateStatus(String id, Map<String, dynamic> payload);
}

class WithdrawalRemoteDataSourceImpl implements WithdrawalRemoteDataSource {
  final ApiServices apiServices;

  const WithdrawalRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getWithdrawalRequests(Map<String, dynamic> queryParams) {
    final sanitizedParams = <String, String>{};
    queryParams.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        sanitizedParams[key] = value.toString().trim();
      }
    });

    final baseUri =
        '${ApiEndpoints.apiUrl}${ApiEndpoints.getReferralRedemptions}';
    final uri = Uri.parse(baseUri)
        .replace(
          queryParameters: sanitizedParams.isEmpty ? null : sanitizedParams,
        )
        .toString();

    return apiServices.getData(uri);
  }

  @override
  Future<Response> updateStatus(String id, Map<String, dynamic> payload) {
    final uri =
        '${ApiEndpoints.apiUrl}${ApiEndpoints.updateWithdrawalStatus}/$id/update-withdrawal-status';
    return apiServices.patchData(uri, payload);
  }
}
