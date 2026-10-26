import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/campaign_entity.dart';
import '../../domain/repositories/campaign_repository.dart';
import '../data_sources/campaign_remote_data_source.dart';
import '../models/campaign_model.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  final CampaignRemoteDataSource remoteDataSource;

  const CampaignRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CampaignsResponseEntity> getCampaigns({
    int page = 1,
    int pageSize = 10,
    String? from,
    String? to,
    String? sortBy,
    String? keyword,
  }) async {
    final Response response = await remoteDataSource.getCampaigns(
      page: page,
      pageSize: pageSize,
      from: from,
      to: to,
      sortBy: sortBy,
      keyword: keyword,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return CampaignsResponseModel.fromJson(rawResponse);
  }

  @override
  Future<CampaignEntity> getCampaignDetail(String id) async {
    final Response response = await remoteDataSource.getCampaignDetail(id);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('doc') && data['doc'] is Map<String, dynamic>) {
        return CampaignModel.fromJson(data['doc'] as Map<String, dynamic>)
            .toEntity();
      } else if (data.containsKey('campaign') &&
          data['campaign'] is Map<String, dynamic>) {
        return CampaignModel.fromJson(
          data['campaign'] as Map<String, dynamic>,
        ).toEntity();
      }
      return CampaignModel.fromJson(data).toEntity();
    }

    return CampaignModel.fromJson(rawResponse).toEntity();
  }

  @override
  Future<CampaignEntity> addCampaign(CreateUpdateCampaignEntity entity) async {
    final model = CreateUpdateCampaignModel.fromEntity(entity);
    final Response response = await remoteDataSource.addCampaign(model.toJson());

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('doc') && data['doc'] is Map<String, dynamic>) {
        return CampaignModel.fromJson(data['doc'] as Map<String, dynamic>)
            .toEntity();
      } else if (data.containsKey('campaign') &&
          data['campaign'] is Map<String, dynamic>) {
        return CampaignModel.fromJson(
          data['campaign'] as Map<String, dynamic>,
        ).toEntity();
      } else if (data.containsKey('_id') || data.containsKey('id')) {
        return CampaignModel.fromJson(data).toEntity();
      }
    }

    return CampaignModel.fromJson(rawResponse).toEntity();
  }

  @override
  Future<CampaignEntity> updateCampaign(
    String id,
    CreateUpdateCampaignEntity entity,
  ) async {
    final model = CreateUpdateCampaignModel.fromEntity(entity);
    final Response response =
        await remoteDataSource.updateCampaign(id, model.toJson());

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('doc') && data['doc'] is Map<String, dynamic>) {
        return CampaignModel.fromJson(data['doc'] as Map<String, dynamic>)
            .toEntity();
      } else if (data.containsKey('campaign') &&
          data['campaign'] is Map<String, dynamic>) {
        return CampaignModel.fromJson(
          data['campaign'] as Map<String, dynamic>,
        ).toEntity();
      } else if (data.containsKey('_id') || data.containsKey('id')) {
        return CampaignModel.fromJson(data).toEntity();
      }
    }

    return CampaignModel.fromJson(rawResponse).toEntity();
  }

  @override
  Future<void> deleteCampaign(String id) async {
    await remoteDataSource.deleteCampaign(id);
  }
}
