import '../entities/influencer_entity.dart';

abstract class MyTeamRepository {
  Future<InfluencerListResponseEntity> getMyInfluencers(
    Map<String, dynamic> queryParams,
  );

  Future<ReferredUserLookupEntity?> searchUserByReferralCode(String code);

  Future<void> requestInfluencerAssignment(Map<String, dynamic> payload);
}

