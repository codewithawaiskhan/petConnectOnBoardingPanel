import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class CompanyDashboardRemoteDataSource {
  Future<Response> getMyCompanyProfile();
  Future<Response> getMyReferralStats({String? from, String? to});
}

class CompanyDashboardRemoteDataSourceImpl
    implements CompanyDashboardRemoteDataSource {
  final ApiServices apiServices;

  const CompanyDashboardRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getMyCompanyProfile() {
    final uri = '${ApiEndpoints.apiUrl}${ApiEndpoints.myCompanyProfile}';
    return apiServices.getData(uri);
  }

  @override
  Future<Response> getMyReferralStats({String? from, String? to}) {
    final queryParams = <String, String>{};
    if (from != null && from.trim().isNotEmpty) {
      queryParams['from'] = from.trim();
    }
    if (to != null && to.trim().isNotEmpty) {
      queryParams['to'] = to.trim();
    }

    final baseUri = '${ApiEndpoints.apiUrl}${ApiEndpoints.myReferralStats}';
    final uri = Uri.parse(baseUri)
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams)
        .toString();

    return apiServices.getData(uri);
  }
}

