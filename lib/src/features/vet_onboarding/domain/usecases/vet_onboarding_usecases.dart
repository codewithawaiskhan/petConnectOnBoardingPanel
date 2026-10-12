import '../entities/doctor_onboarding_entity.dart';
import '../repositories/vet_onboarding_repository.dart';

class VetOnboardingUseCases {
  final VetOnboardingRepository repository;

  const VetOnboardingUseCases({required this.repository});

  Future<DoctorDataEntryResponseEntity> submitDoctorDataEntry(
    DoctorOnboardingEntity entity,
  ) async {
    return await repository.submitDoctorDataEntry(entity);
  }
}

