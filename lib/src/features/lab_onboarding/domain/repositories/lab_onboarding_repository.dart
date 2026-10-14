import '../entities/lab_entity.dart';
import '../entities/lab_onboarding_entity.dart';

abstract class LabOnboardingRepository {
  Future<LabDataEntryResponseEntity> submitLabDataEntry(
    LabOnboardingEntity entity,
  );

  Future<LabListResponseEntity> getLabs({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
  });

  Future<LabDetailResponseEntity> getLabDetail(String id);

  Future<LabTestCategoryListResponseEntity> getLabTestCategories({
    int pageSize = 100,
  });
}
