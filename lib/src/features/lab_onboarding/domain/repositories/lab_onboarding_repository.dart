import '../entities/lab_entity.dart';
import '../entities/lab_onboarding_entity.dart';
import '../entities/update_lab_entity.dart';

abstract class LabOnboardingRepository {
  Future<LabDataEntryResponseEntity> submitLabDataEntry(
    LabOnboardingEntity entity,
  );

  Future<LabListResponseEntity> getLabs({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
    String? from,
    String? to,
    String? countryCode,
  });

  Future<LabDetailResponseEntity> getLabDetail(String id);

  Future<LabTestCategoryListResponseEntity> getLabTestCategories({
    int pageSize = 100,
  });

  Future<LabActionResponseEntity> updateLab(
    String id,
    UpdateLabEntity entity,
  );

  Future<LabActionResponseEntity> deleteLab(String id);
}
