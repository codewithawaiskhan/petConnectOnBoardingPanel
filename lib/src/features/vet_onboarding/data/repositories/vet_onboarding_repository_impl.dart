import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/doctor_onboarding_entity.dart';
import '../../domain/repositories/vet_onboarding_repository.dart';
import '../data_sources/vet_onboarding_remote_data_source.dart';
import '../models/doctor_onboarding_model.dart';

class VetOnboardingRepositoryImpl implements VetOnboardingRepository {
  final VetOnboardingRemoteDataSource remoteDataSource;

  const VetOnboardingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DoctorDataEntryResponseEntity> submitDoctorDataEntry(
    DoctorOnboardingEntity entity,
  ) async {
    // Explicitly map Domain Entity to Data Model
    final model = DoctorOnboardingModel.fromEntity(entity);

    final Response response = await remoteDataSource.submitDoctorDataEntry(model);

    final Map<String, dynamic> rawResponse = response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return DoctorDataEntryResponseModel.fromJson(rawResponse);
  }
}

