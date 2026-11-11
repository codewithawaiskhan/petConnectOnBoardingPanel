import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class DashboardRemoteDataSource {
  Future<Response> getAdminDashboardData({String? from, String? to});
  Future<Response> getTopCountries({
    String? countryCode,
    String? from,
    String? to,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiServices apiServices;

  DashboardRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getAdminDashboardData({String? from, String? to}) async {
    final queryParams = <String, String>{};
    if (from != null && from.trim().isNotEmpty) {
      queryParams['from'] = from.trim();
    }
    if (to != null && to.trim().isNotEmpty) {
      queryParams['to'] = to.trim();
    }

    final uri = Uri.parse(ApiEndpoints.adminDashboardData)
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams)
        .toString();

    return await apiServices.getData(uri);
  }

  @override
  Future<Response> getTopCountries({
    String? countryCode,
    String? from,
    String? to,
  }) async {
    final queryParams = <String, String>{};
    if (countryCode != null && countryCode.trim().isNotEmpty) {
      queryParams['countryCode'] = countryCode.trim().toUpperCase();
    }
    if (from != null && from.trim().isNotEmpty) {
      queryParams['from'] = from.trim();
    }
    if (to != null && to.trim().isNotEmpty) {
      queryParams['to'] = to.trim();
    }

    final uri = Uri.parse(ApiEndpoints.topCountries)
        .replace(queryParameters: queryParams.isEmpty ? null : queryParams)
        .toString();

    return await apiServices.getData(uri);
  }
}
