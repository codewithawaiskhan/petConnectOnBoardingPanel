import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class CompanyDashboardRemoteDataSource {
  Future<Response> getMyCompanyDashboard({String? from, String? to});
}

class CompanyDashboardRemoteDataSourceImpl
    implements CompanyDashboardRemoteDataSource {
  final ApiServices apiServices;

  const CompanyDashboardRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getMyCompanyDashboard({String? from, String? to}) {
    final queryParams = <String, String>{};
    if (from != null && from.trim().isNotEmpty) {
      queryParams['from'] = from.trim();
    }
    if (to != null && to.trim().isNotEmpty) {
      queryParams['to'] = to.trim();
    }

    final baseUri = '${ApiEndpoints.apiUrl}${ApiEndpoints.myCompanyDashboard}';
    final uri = Uri.parse(baseUri)
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams)
        .toString();

    return apiServices.getData(uri);
  }
}
