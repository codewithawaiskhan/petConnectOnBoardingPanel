import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class RemindersRemoteDataSource {
  Future<Response> getRemindersByUserId(String userId);
}

class RemindersRemoteDataSourceImpl implements RemindersRemoteDataSource {
  final ApiServices apiServices;

  const RemindersRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getRemindersByUserId(String userId) {
    return apiServices.getData(ApiEndpoints.remindersByUser(userId));
  }
}
