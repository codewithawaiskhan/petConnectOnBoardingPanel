import '../entities/campaign_entity.dart';

abstract class CampaignRepository {
  Future<CampaignsResponseEntity> getCampaigns({
    int page = 1,
    int pageSize = 10,
    String? from,
    String? to,
    String? sortBy,
    String? keyword,
  });

  Future<CampaignEntity> getCampaignDetail(String id);
  Future<CampaignEntity> addCampaign(CreateUpdateCampaignEntity entity);
  Future<CampaignEntity> updateCampaign(
    String id,
    CreateUpdateCampaignEntity entity,
  );
  Future<void> deleteCampaign(String id);
}
