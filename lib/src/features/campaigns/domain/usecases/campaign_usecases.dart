import '../entities/campaign_entity.dart';
import '../repositories/campaign_repository.dart';

class CampaignUseCases {
  final CampaignRepository repository;

  const CampaignUseCases({required this.repository});

  Future<CampaignsResponseEntity> getCampaigns({
    int page = 1,
    int pageSize = 10,
    String? from,
    String? to,
    String? sortBy,
    String? keyword,
  }) {
    return repository.getCampaigns(
      page: page,
      pageSize: pageSize,
      from: from,
      to: to,
      sortBy: sortBy,
      keyword: keyword,
    );
  }

  Future<CampaignEntity> getCampaignDetail(String id) {
    return repository.getCampaignDetail(id);
  }

  Future<CampaignEntity> addCampaign(CreateUpdateCampaignEntity entity) {
    return repository.addCampaign(entity);
  }

  Future<CampaignEntity> updateCampaign(
    String id,
    CreateUpdateCampaignEntity entity,
  ) {
    return repository.updateCampaign(id, entity);
  }

  Future<void> deleteCampaign(String id) {
    return repository.deleteCampaign(id);
  }
}
