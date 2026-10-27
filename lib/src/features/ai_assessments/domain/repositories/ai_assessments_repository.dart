import '../entities/ai_assessment_entity.dart';

abstract class AiAssessmentsRepository {
  Future<List<AiAssessmentEntity>> getAiAssessmentsByUserId(String userId);
}
