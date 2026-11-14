import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class CompanyPayoutsRemoteDataSource {
  Future<Response> getAllPayouts(Map<String, dynamic> queryParams);
  Future<Response> updatePayoutStatus(
    String id,
    Map<String, dynamic> payload,
  );
}

class CompanyPayoutsRemoteDataSourceImpl
    implements CompanyPayoutsRemoteDataSource {
  final ApiServices apiServices;

  const CompanyPayoutsRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getAllPayouts(Map<String, dynamic> queryParams) {
    final sanitized = <String, String>{};
    queryParams.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        sanitized[key] = value.toString().trim();
      }
    });

    final baseUri =
        '${ApiEndpoints.apiUrl}${ApiEndpoints.adminReferralRedemptions}';
    final uri = Uri.parse(baseUri)
        .replace(queryParameters: sanitized.isEmpty ? null : sanitized)
        .toString();

    return apiServices.getData(uri);
  }

  @override
  Future<Response> updatePayoutStatus(
    String id,
    Map<String, dynamic> payload,
  ) {
    final uri =
        '${ApiEndpoints.apiUrl}${ApiEndpoints.updateWithdrawalStatusEndpoint(id)}';
    return apiServices.patchData(uri, payload);
  }
}

