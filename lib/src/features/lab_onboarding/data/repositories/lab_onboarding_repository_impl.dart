import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/lab_entity.dart';
import '../../domain/entities/lab_onboarding_entity.dart';
import '../../domain/repositories/lab_onboarding_repository.dart';
import '../data_sources/lab_onboarding_remote_data_source.dart';
import '../models/lab_model.dart';
import '../models/lab_onboarding_model.dart';

class LabOnboardingRepositoryImpl implements LabOnboardingRepository {
  final LabOnboardingRemoteDataSource remoteDataSource;

  const LabOnboardingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LabDataEntryResponseEntity> submitLabDataEntry(
    LabOnboardingEntity entity,
  ) async {
    final model = LabOnboardingModel.fromEntity(entity);
    final Response response = await remoteDataSource.submitLabDataEntry(model);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return LabDataEntryResponseModel.fromJson(rawResponse);
  }

  @override
  Future<LabListResponseEntity> getLabs({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
  }) async {
    final Response response = await remoteDataSource.getLabs(
      page: page,
      pageSize: pageSize,
      status: status,
      keyword: keyword,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return LabListResponseModel.fromJson(rawResponse);
  }

  @override
  Future<LabDetailResponseEntity> getLabDetail(String id) async {
    final Response response = await remoteDataSource.getLabDetail(id);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return LabDetailResponseModel.fromJson(rawResponse);
  }

  @override
  Future<LabTestCategoryListResponseEntity> getLabTestCategories({
    int pageSize = 100,
  }) async {
    final Response response = await remoteDataSource.getLabTestCategories(
      pageSize: pageSize,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return LabTestCategoryListResponseModel.fromJson(rawResponse);
  }
}
