import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';
import '../models/service_provider_onboarding_model.dart';

abstract class ServiceProviderOnboardingRemoteDataSource {
  Future<Response> submitServiceProviderDataEntry(ServiceProviderOnboardingModel model);
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
}

