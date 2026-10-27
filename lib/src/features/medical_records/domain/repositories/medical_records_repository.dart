import '../entities/medical_record_entity.dart';

abstract class MedicalRecordsRepository {
  Future<List<MedicalRecordEntity>> getMedicalRecordsByUserId(String userId);
}
