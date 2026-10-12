import '../entities/service_provider_onboarding_entity.dart';
import '../repositories/service_provider_onboarding_repository.dart';

class ServiceProviderOnboardingUseCases {
  final ServiceProviderOnboardingRepository repository;

  const ServiceProviderOnboardingUseCases({required this.repository});

  Future<ServiceProviderDataEntryResponseEntity> submitServiceProviderDataEntry(
    ServiceProviderOnboardingEntity entity,
  ) async {
    return await repository.submitServiceProviderDataEntry(entity);
  }
}

