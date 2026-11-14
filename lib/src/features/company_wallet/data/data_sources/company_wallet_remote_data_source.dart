import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class CompanyWalletRemoteDataSource {
  Future<Response> getMyReferralBalance();
  Future<Response> getMyCommissionLedger(Map<String, dynamic> queryParams);
}

class CompanyWalletRemoteDataSourceImpl
    implements CompanyWalletRemoteDataSource {
  final ApiServices apiServices;

  const CompanyWalletRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getMyReferralBalance() {
    final uri = '${ApiEndpoints.apiUrl}${ApiEndpoints.myReferralBalance}';
    return apiServices.getData(uri);
  }

  @override
  Future<Response> getMyCommissionLedger(Map<String, dynamic> queryParams) {
    final sanitized = <String, String>{};
    queryParams.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        sanitized[key] = value.toString().trim();
      }
    });

    final baseUri = '${ApiEndpoints.apiUrl}${ApiEndpoints.myCommissionLedger}';
    final uri = Uri.parse(baseUri)
        .replace(queryParameters: sanitized.isEmpty ? null : sanitized)
        .toString();

    return apiServices.getData(uri);
  }
}

