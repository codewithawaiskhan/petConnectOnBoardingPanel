import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';
import '../models/service_provider_onboarding_model.dart';

abstract class ServiceProviderOnboardingRemoteDataSource {
  Future<Response> submitServiceProviderDataEntry(
    ServiceProviderOnboardingModel model,
  );
  Future<Response> getServiceProviders({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
  });
  Future<Response> getServiceProviderDetail(String id);
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

    final uri = Uri.parse(
      ApiEndpoints.serviceProviders,
    ).replace(queryParameters: queryParams).toString();

    return await apiServices.getData(uri);
  }

  @override
  Future<Response> getServiceProviderDetail(String id) async {
    return await apiServices.getData(ApiEndpoints.serviceProviderDetail(id));
  }
}
