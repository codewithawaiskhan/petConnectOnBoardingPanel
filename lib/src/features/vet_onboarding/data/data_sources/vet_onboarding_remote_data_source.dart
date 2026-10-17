import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';
import '../models/doctor_onboarding_model.dart';
import '../models/update_doctor_model.dart';

abstract class VetOnboardingRemoteDataSource {
  Future<Response> submitDoctorDataEntry(DoctorOnboardingModel model);
  Future<Response> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
    String? from,
    String? to,
    String? countryCode,
  });
  Future<Response> getDoctorDetail(String id);
  Future<Response> updateDoctor(String id, UpdateDoctorModel model);
  Future<Response> deleteDoctor(String id);
}

class VetOnboardingRemoteDataSourceImpl
    implements VetOnboardingRemoteDataSource {
  final ApiServices apiServices;

  VetOnboardingRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> submitDoctorDataEntry(DoctorOnboardingModel model) async {
    return await apiServices.postData(
      ApiEndpoints.doctorDataEntry,
      model.toJson(),
    );
  }

  @override
  Future<Response> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
    String? from,
    String? to,
    String? countryCode,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      'sortBy': 'createdAt_descending',
    };
    if (status != null && status.isNotEmpty && status != 'All') {
      queryParams['status'] = status;
    }
    if (keyword != null && keyword.trim().isNotEmpty) {
      queryParams['keyword'] = keyword.trim();
    }
    if (from != null && from.trim().isNotEmpty) {
      queryParams['from'] = from.trim();
    }
    if (to != null && to.trim().isNotEmpty) {
      queryParams['to'] = to.trim();
    }
    if (countryCode != null && countryCode.trim().isNotEmpty) {
      final code = countryCode.trim().toUpperCase();
      if (code.length == 2) {
        queryParams['countryCode'] = code;
      }
    }

    final uri = Uri.parse(
      ApiEndpoints.doctors,
    ).replace(queryParameters: queryParams).toString();

    return await apiServices.getData(uri);
  }

  @override
  Future<Response> getDoctorDetail(String id) async {
    return await apiServices.getData(ApiEndpoints.doctorDetail(id));
  }

  @override
  Future<Response> updateDoctor(String id, UpdateDoctorModel model) async {
    return await apiServices.patchData(
      ApiEndpoints.updateDoctor(id),
      model.toJson(),
    );
  }

  @override
  Future<Response> deleteDoctor(String id) async {
    return await apiServices.deleteData(ApiEndpoints.deleteDoctor(id));
  }
}
