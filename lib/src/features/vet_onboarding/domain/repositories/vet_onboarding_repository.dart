import '../entities/doctor_onboarding_entity.dart';

abstract class VetOnboardingRepository {
  Future<DoctorDataEntryResponseEntity> submitDoctorDataEntry(
    DoctorOnboardingEntity entity,
  );
}

