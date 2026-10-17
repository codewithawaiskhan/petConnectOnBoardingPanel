import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class DashboardRemoteDataSource {
  Future<Response> getAdminDashboardData();
  Future<Response> getTopCountries({String? countryCode});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiServices apiServices;

  DashboardRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getAdminDashboardData() async {
    return await apiServices.getData(ApiEndpoints.adminDashboardData);
  }

  @override
  Future<Response> getTopCountries({String? countryCode}) async {
    String url = ApiEndpoints.topCountries;
    if (countryCode != null && countryCode.trim().isNotEmpty) {
      url = "$url?countryCode=${countryCode.trim().toUpperCase()}";
    }
    return await apiServices.getData(url);
  }
}
