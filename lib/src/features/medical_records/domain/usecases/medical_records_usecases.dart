import '../entities/medical_record_entity.dart';
import '../repositories/medical_records_repository.dart';

class GetMedicalRecordsByUserIdUseCase {
  final MedicalRecordsRepository repository;

  const GetMedicalRecordsByUserIdUseCase({required this.repository});

  Future<List<MedicalRecordEntity>> call(String userId) {
    return repository.getMedicalRecordsByUserId(userId);
  }
}

class MedicalRecordsUseCases {
  final MedicalRecordsRepository repository;

  const MedicalRecordsUseCases({required this.repository});

  Future<List<MedicalRecordEntity>> getMedicalRecordsByUserId(String userId) {
    return repository.getMedicalRecordsByUserId(userId);
  }
}
