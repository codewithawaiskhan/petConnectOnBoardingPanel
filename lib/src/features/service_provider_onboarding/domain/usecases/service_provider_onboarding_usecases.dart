import '../entities/service_provider_list_entity.dart';
import '../entities/service_provider_onboarding_entity.dart';
import '../entities/update_service_provider_entity.dart';
import '../repositories/service_provider_onboarding_repository.dart';

class ServiceProviderOnboardingUseCases {
  final ServiceProviderOnboardingRepository repository;

  const ServiceProviderOnboardingUseCases({required this.repository});

  Future<ServiceProviderDataEntryResponseEntity> submitServiceProviderDataEntry(
    ServiceProviderOnboardingEntity entity,
  ) async {
    return await repository.submitServiceProviderDataEntry(entity);
  }

  Future<ServiceProviderListResponseEntity> getServiceProviders({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
  }) async {
    return await repository.getServiceProviders(
      page: page,
      pageSize: pageSize,
      status: status,
      keyword: keyword,
    );
  }

  Future<ServiceProviderDetailResponseEntity> getServiceProviderDetail(
    String id,
  ) async {
    return await repository.getServiceProviderDetail(id);
  }

  Future<ServiceProviderActionResponseEntity> updateServiceProvider(
    String id,
    UpdateServiceProviderEntity entity,
  ) async {
    return await repository.updateServiceProvider(id, entity);
  }

  Future<ServiceProviderActionResponseEntity> deleteServiceProvider(
    String id,
  ) async {
    return await repository.deleteServiceProvider(id);
  }
}
