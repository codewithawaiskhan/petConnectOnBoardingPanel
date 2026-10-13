import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class DashboardRemoteDataSource {
  Future<Response> getAdminDashboardData();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiServices apiServices;

  DashboardRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getAdminDashboardData() async {
    return await apiServices.getData(ApiEndpoints.adminDashboardData);
  }
}
