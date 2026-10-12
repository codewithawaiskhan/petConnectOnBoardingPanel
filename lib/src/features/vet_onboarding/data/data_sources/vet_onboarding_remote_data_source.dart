import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';
import '../models/doctor_onboarding_model.dart';

abstract class VetOnboardingRemoteDataSource {
  Future<Response> submitDoctorDataEntry(DoctorOnboardingModel model);
}

class VetOnboardingRemoteDataSourceImpl implements VetOnboardingRemoteDataSource {
  final ApiServices apiServices;

  VetOnboardingRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> submitDoctorDataEntry(DoctorOnboardingModel model) async {
    return await apiServices.postData(
      ApiEndpoints.doctorDataEntry,
      model.toJson(),
    );
  }
}

