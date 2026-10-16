import '../entities/service_provider_list_entity.dart';
import '../entities/service_provider_onboarding_entity.dart';
import '../entities/update_service_provider_entity.dart';

abstract class ServiceProviderOnboardingRepository {
  Future<ServiceProviderDataEntryResponseEntity> submitServiceProviderDataEntry(
    ServiceProviderOnboardingEntity entity,
  );
  Future<ServiceProviderListResponseEntity> getServiceProviders({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
  });
  Future<ServiceProviderDetailResponseEntity> getServiceProviderDetail(
    String id,
  );
  Future<ServiceProviderActionResponseEntity> updateServiceProvider(
    String id,
    UpdateServiceProviderEntity entity,
  );
  Future<ServiceProviderActionResponseEntity> deleteServiceProvider(String id);
}
