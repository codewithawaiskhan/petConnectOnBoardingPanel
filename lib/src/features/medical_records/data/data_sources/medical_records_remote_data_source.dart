import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class MedicalRecordsRemoteDataSource {
  Future<Response> getMedicalRecordsByUserId(String userId);
}

class MedicalRecordsRemoteDataSourceImpl implements MedicalRecordsRemoteDataSource {
  final ApiServices apiServices;

  const MedicalRecordsRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getMedicalRecordsByUserId(String userId) {
    return apiServices.getData(ApiEndpoints.medicalRecordsByUser(userId));
  }
}
