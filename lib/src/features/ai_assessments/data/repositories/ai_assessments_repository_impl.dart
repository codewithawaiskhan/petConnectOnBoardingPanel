import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/ai_assessment_entity.dart';
import '../../domain/repositories/ai_assessments_repository.dart';
import '../data_sources/ai_assessments_remote_data_source.dart';
import '../models/ai_assessment_model.dart';

class AiAssessmentsRepositoryImpl implements AiAssessmentsRepository {
  final AiAssessmentsRemoteDataSource remoteDataSource;

  const AiAssessmentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AiAssessmentEntity>> getAiAssessmentsByUserId(String userId) async {
    final Response response =
        await remoteDataSource.getAiAssessmentsByUserId(userId);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    List rawDocs = const [];
    final data = rawResponse['data'];

    if (data is Map<String, dynamic>) {
      if (data['docs'] is List) {
        rawDocs = data['docs'] as List;
      } else if (data['assessments'] is List) {
        rawDocs = data['assessments'] as List;
      }
    } else if (data is List) {
      rawDocs = data;
    } else if (rawResponse['docs'] is List) {
      rawDocs = rawResponse['docs'] as List;
    } else if (rawResponse['assessments'] is List) {
      rawDocs = rawResponse['assessments'] as List;
    }

    // STRICT CLEAN ARCHITECTURE TYPE RULE 6:
    // ALWAYS explicitly map as `.map<AiAssessmentEntity>(...)`
    return rawDocs
        .whereType<Map<String, dynamic>>()
        .map<AiAssessmentEntity>((doc) => AiAssessmentModel.fromJson(doc).toEntity())
        .toList();
  }
}
