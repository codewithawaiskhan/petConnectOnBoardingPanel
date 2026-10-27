import '../entities/ai_assessment_entity.dart';
import '../repositories/ai_assessments_repository.dart';

class GetAiAssessmentsByUserIdUseCase {
  final AiAssessmentsRepository repository;

  const GetAiAssessmentsByUserIdUseCase({required this.repository});

  Future<List<AiAssessmentEntity>> call(String userId) {
    return repository.getAiAssessmentsByUserId(userId);
  }
}

class AiAssessmentsUseCases {
  final AiAssessmentsRepository repository;

  const AiAssessmentsUseCases({required this.repository});

  Future<List<AiAssessmentEntity>> getAiAssessmentsByUserId(String userId) {
    return repository.getAiAssessmentsByUserId(userId);
  }
}
