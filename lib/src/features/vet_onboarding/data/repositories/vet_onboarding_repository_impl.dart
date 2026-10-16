import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/doctor_list_entity.dart';
import '../../domain/entities/doctor_onboarding_entity.dart';
import '../../domain/entities/update_doctor_entity.dart';
import '../../domain/repositories/vet_onboarding_repository.dart';
import '../data_sources/vet_onboarding_remote_data_source.dart';
import '../models/doctor_list_model.dart';
import '../models/doctor_onboarding_model.dart';
import '../models/update_doctor_model.dart';

class VetOnboardingRepositoryImpl implements VetOnboardingRepository {
  final VetOnboardingRemoteDataSource remoteDataSource;

  const VetOnboardingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DoctorDataEntryResponseEntity> submitDoctorDataEntry(
    DoctorOnboardingEntity entity,
  ) async {
    final model = DoctorOnboardingModel.fromEntity(entity);

    final Response response = await remoteDataSource.submitDoctorDataEntry(
      model,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return DoctorDataEntryResponseModel.fromJson(rawResponse);
  }

  @override
  Future<DoctorListResponseEntity> getDoctors({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
  }) async {
    final Response response = await remoteDataSource.getDoctors(
      page: page,
      pageSize: pageSize,
      status: status,
      keyword: keyword,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return DoctorListResponseModel.fromJson(rawResponse);
  }

  @override
  Future<DoctorDetailResponseEntity> getDoctorDetail(String id) async {
    final Response response = await remoteDataSource.getDoctorDetail(id);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return DoctorDetailResponseModel.fromJson(rawResponse);
  }

  @override
  Future<DoctorActionResponseEntity> updateDoctor(
    String id,
    UpdateDoctorEntity entity,
  ) async {
    final model = UpdateDoctorModel.fromEntity(entity);
    final Response response = await remoteDataSource.updateDoctor(id, model);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return DoctorActionResponseModel.fromJson(rawResponse);
  }

  @override
  Future<DoctorActionResponseEntity> deleteDoctor(String id) async {
    final Response response = await remoteDataSource.deleteDoctor(id);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return DoctorActionResponseModel.fromJson(rawResponse);
  }
}
