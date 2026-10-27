import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../../domain/repositories/medical_records_repository.dart';
import '../data_sources/medical_records_remote_data_source.dart';
import '../models/medical_record_model.dart';

class MedicalRecordsRepositoryImpl implements MedicalRecordsRepository {
  final MedicalRecordsRemoteDataSource remoteDataSource;

  const MedicalRecordsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MedicalRecordEntity>> getMedicalRecordsByUserId(String userId) async {
    final Response response =
        await remoteDataSource.getMedicalRecordsByUserId(userId);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    List rawDocs = const [];
    final data = rawResponse['data'];

    if (data is Map<String, dynamic>) {
      if (data['docs'] is List) {
        rawDocs = data['docs'] as List;
      } else if (data['records'] is List) {
        rawDocs = data['records'] as List;
      }
    } else if (data is List) {
      rawDocs = data;
    } else if (rawResponse['docs'] is List) {
      rawDocs = rawResponse['docs'] as List;
    } else if (rawResponse['records'] is List) {
      rawDocs = rawResponse['records'] as List;
    }

    // STRICT CLEAN ARCHITECTURE TYPE RULE 6:
    // ALWAYS explicitly map as `.map<MedicalRecordEntity>(...)`
    return rawDocs
        .whereType<Map<String, dynamic>>()
        .map<MedicalRecordEntity>((doc) => MedicalRecordModel.fromJson(doc).toEntity())
        .toList();
  }
}
