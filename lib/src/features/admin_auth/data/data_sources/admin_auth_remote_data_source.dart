import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class AdminAuthRemoteDataSource {
  Future<Response> login(String identifier, String password);
}

class AdminAuthRemoteDataSourceImpl implements AdminAuthRemoteDataSource {
  final ApiServices apiServices;

  AdminAuthRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> login(String identifier, String password) async {
    return await apiServices.postData(
      ApiEndpoints.adminLogin,
      {'identifier': identifier, 'password': password},
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    );
  }
}
