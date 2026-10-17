import '../entities/lab_entity.dart';
import '../entities/lab_onboarding_entity.dart';
import '../entities/update_lab_entity.dart';
import '../repositories/lab_onboarding_repository.dart';

class LabOnboardingUseCases {
  final LabOnboardingRepository repository;

  const LabOnboardingUseCases({required this.repository});

  Future<LabDataEntryResponseEntity> submitLabDataEntry(
    LabOnboardingEntity entity,
  ) async {
    return await repository.submitLabDataEntry(entity);
  }

  Future<LabListResponseEntity> getLabs({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
    String? from,
    String? to,
    String? countryCode,
  }) async {
    return await repository.getLabs(
      page: page,
      pageSize: pageSize,
      status: status,
      keyword: keyword,
      from: from,
      to: to,
      countryCode: countryCode,
    );
  }

  Future<LabDetailResponseEntity> getLabDetail(String id) async {
    return await repository.getLabDetail(id);
  }

  Future<LabTestCategoryListResponseEntity> getLabTestCategories({
    int pageSize = 100,
  }) async {
    return await repository.getLabTestCategories(pageSize: pageSize);
  }

  Future<LabActionResponseEntity> updateLab(
    String id,
    UpdateLabEntity entity,
  ) async {
    return await repository.updateLab(id, entity);
  }

  Future<LabActionResponseEntity> deleteLab(String id) async {
    return await repository.deleteLab(id);
  }
}
