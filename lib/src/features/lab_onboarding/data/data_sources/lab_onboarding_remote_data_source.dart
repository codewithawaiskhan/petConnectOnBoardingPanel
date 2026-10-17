import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';
import '../models/lab_onboarding_model.dart';
import '../models/update_lab_model.dart';

abstract class LabOnboardingRemoteDataSource {
  Future<Response> submitLabDataEntry(LabOnboardingModel model);

  Future<Response> getLabs({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
    String? from,
    String? to,
    String? countryCode,
  });

  Future<Response> getLabDetail(String id);

  Future<Response> getLabTestCategories({int pageSize = 100});

  Future<Response> updateLab(String id, UpdateLabModel model);

  Future<Response> deleteLab(String id);
}

class LabOnboardingRemoteDataSourceImpl
    implements LabOnboardingRemoteDataSource {
  final ApiServices apiServices;

  LabOnboardingRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> submitLabDataEntry(LabOnboardingModel model) async {
    return await apiServices.postData(
      ApiEndpoints.labDataEntry,
      model.toJson(),
    );
  }

  @override
  Future<Response> getLabs({
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
      final countryVal = countryCode.trim();
      queryParams['countryCode'] = countryVal;
      queryParams['countryName'] = countryVal;
      queryParams['country'] = countryVal;
    }

    final uri = Uri.parse(
      ApiEndpoints.labs,
    ).replace(queryParameters: queryParams).toString();

    return await apiServices.getData(uri);
  }

  @override
  Future<Response> getLabDetail(String id) async {
    return await apiServices.getData(ApiEndpoints.labDetail(id));
  }

  @override
  Future<Response> getLabTestCategories({int pageSize = 100}) async {
    final queryParams = <String, String>{'pageSize': pageSize.toString()};

    final uri = Uri.parse(
      ApiEndpoints.labTestCategories,
    ).replace(queryParameters: queryParams).toString();

    return await apiServices.getData(uri);
  }

  @override
  Future<Response> updateLab(String id, UpdateLabModel model) async {
    return await apiServices.patchData(
      ApiEndpoints.updateLab(id),
      model.toJson(),
    );
  }

  @override
  Future<Response> deleteLab(String id) async {
    return await apiServices.deleteData(ApiEndpoints.deleteLab(id));
  }
}
