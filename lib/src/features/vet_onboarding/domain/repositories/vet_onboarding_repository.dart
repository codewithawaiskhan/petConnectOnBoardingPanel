import '../entities/doctor_list_entity.dart';
import '../entities/doctor_onboarding_entity.dart';
import '../entities/update_doctor_entity.dart';

abstract class VetOnboardingRepository {
  Future<DoctorDataEntryResponseEntity> submitDoctorDataEntry(
    DoctorOnboardingEntity entity,
  );
  Future<DoctorListResponseEntity> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
  });
  Future<DoctorDetailResponseEntity> getDoctorDetail(String id);
  Future<DoctorActionResponseEntity> updateDoctor(
    String id,
    UpdateDoctorEntity entity,
  );
  Future<DoctorActionResponseEntity> deleteDoctor(String id);
}
