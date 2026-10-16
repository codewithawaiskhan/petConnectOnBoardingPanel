import '../entities/doctor_list_entity.dart';
import '../entities/doctor_onboarding_entity.dart';
import '../entities/update_doctor_entity.dart';
import '../repositories/vet_onboarding_repository.dart';

class VetOnboardingUseCases {
  final VetOnboardingRepository repository;

  const VetOnboardingUseCases({required this.repository});

  Future<DoctorDataEntryResponseEntity> submitDoctorDataEntry(
    DoctorOnboardingEntity entity,
  ) async {
    return await repository.submitDoctorDataEntry(entity);
  }

  Future<DoctorListResponseEntity> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
  }) async {
    return await repository.getDoctors(
      page: page,
      pageSize: pageSize,
      status: status,
      keyword: keyword,
    );
  }

  Future<DoctorDetailResponseEntity> getDoctorDetail(String id) async {
    return await repository.getDoctorDetail(id);
  }

  Future<DoctorActionResponseEntity> updateDoctor(
    String id,
    UpdateDoctorEntity entity,
  ) async {
    return await repository.updateDoctor(id, entity);
  }

  Future<DoctorActionResponseEntity> deleteDoctor(String id) async {
    return await repository.deleteDoctor(id);
  }
}
