import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class AiAssessmentsRemoteDataSource {
  Future<Response> getAiAssessmentsByUserId(String userId);
}

class AiAssessmentsRemoteDataSourceImpl implements AiAssessmentsRemoteDataSource {
  final ApiServices apiServices;

  const AiAssessmentsRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getAiAssessmentsByUserId(String userId) {
    return apiServices.getData(ApiEndpoints.aiAssessmentsByUser(userId));
  }
}
