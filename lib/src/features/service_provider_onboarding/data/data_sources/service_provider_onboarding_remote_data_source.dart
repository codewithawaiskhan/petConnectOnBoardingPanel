import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';
import '../models/service_provider_onboarding_model.dart';
import '../models/update_service_provider_model.dart';

abstract class ServiceProviderOnboardingRemoteDataSource {
  Future<Response> submitServiceProviderDataEntry(
    ServiceProviderOnboardingModel model,
  );
  Future<Response> getServiceProviders({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
    String? from,
    String? to,
    String? countryCode,
  });
  Future<Response> getServiceProviderDetail(String id);
  Future<Response> updateServiceProvider(
    String id,
    UpdateServiceProviderModel model,
  );
  Future<Response> deleteServiceProvider(String id);
}

class ServiceProviderOnboardingRemoteDataSourceImpl
    implements ServiceProviderOnboardingRemoteDataSource {
  final ApiServices apiServices;

  ServiceProviderOnboardingRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> submitServiceProviderDataEntry(
    ServiceProviderOnboardingModel model,
  ) async {
    return await apiServices.postData(
      ApiEndpoints.serviceProviderDataEntry,
      model.toJson(),
    );
  }

  @override
  Future<Response> getServiceProviders({
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
      ApiEndpoints.serviceProviders,
    ).replace(queryParameters: queryParams).toString();

    return await apiServices.getData(uri);
  }

  @override
  Future<Response> getServiceProviderDetail(String id) async {
    return await apiServices.getData(ApiEndpoints.serviceProviderDetail(id));
  }

  @override
  Future<Response> updateServiceProvider(
    String id,
    UpdateServiceProviderModel model,
  ) async {
    return await apiServices.patchData(
      ApiEndpoints.updateServiceProvider(id),
      model.toJson(),
    );
  }

  @override
  Future<Response> deleteServiceProvider(String id) async {
    return await apiServices.deleteData(ApiEndpoints.deleteServiceProvider(id));
  }
}
