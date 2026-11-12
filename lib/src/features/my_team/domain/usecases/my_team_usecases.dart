import '../entities/influencer_entity.dart';
import '../repositories/my_team_repository.dart';

class GetMyInfluencersUseCase {
  final MyTeamRepository repository;

  const GetMyInfluencersUseCase({required this.repository});

  Future<InfluencerListResponseEntity> call(Map<String, dynamic> queryParams) {
    return repository.getMyInfluencers(queryParams);
  }
}

class SearchUserByReferralCodeUseCase {
  final MyTeamRepository repository;

  const SearchUserByReferralCodeUseCase({required this.repository});

  Future<ReferredUserLookupEntity?> call(String code) {
    return repository.searchUserByReferralCode(code);
  }
}

class CreateAssignInfluencerRequestUseCase {
  final MyTeamRepository repository;

  const CreateAssignInfluencerRequestUseCase({required this.repository});

  Future<void> call(Map<String, dynamic> payload) {
    return repository.requestInfluencerAssignment(payload);
  }
}

