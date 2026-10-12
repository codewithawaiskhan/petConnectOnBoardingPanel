import '../entities/service_provider_onboarding_entity.dart';

abstract class ServiceProviderOnboardingRepository {
  Future<ServiceProviderDataEntryResponseEntity> submitServiceProviderDataEntry(
    ServiceProviderOnboardingEntity entity,
  );
}

