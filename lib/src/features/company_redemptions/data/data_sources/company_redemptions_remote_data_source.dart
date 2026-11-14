import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class CompanyRedemptionsRemoteDataSource {
  Future<Response> getMyRedemptions(Map<String, dynamic> queryParams);
  Future<Response> requestPayPalRedemption(Map<String, dynamic> payload);
}

class CompanyRedemptionsRemoteDataSourceImpl
    implements CompanyRedemptionsRemoteDataSource {
  final ApiServices apiServices;

  const CompanyRedemptionsRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getMyRedemptions(Map<String, dynamic> queryParams) {
    final sanitized = <String, String>{};
    queryParams.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        sanitized[key] = value.toString().trim();
      }
    });

    final baseUri = '${ApiEndpoints.apiUrl}${ApiEndpoints.myRedemptions}';
    final uri = Uri.parse(baseUri)
        .replace(queryParameters: sanitized.isEmpty ? null : sanitized)
        .toString();

    return apiServices.getData(uri);
  }

  @override
  Future<Response> requestPayPalRedemption(Map<String, dynamic> payload) {
    final uri = '${ApiEndpoints.apiUrl}${ApiEndpoints.requestPayPalRedemption}';
    return apiServices.postData(uri, payload);
  }
}

