import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/influencer_entity.dart';
import '../../domain/repositories/my_team_repository.dart';
import '../data_sources/my_team_remote_data_source.dart';
import '../models/influencer_model.dart';

class MyTeamRepositoryImpl implements MyTeamRepository {
  final MyTeamRemoteDataSource remoteDataSource;

  const MyTeamRepositoryImpl({required this.remoteDataSource});

  @override
  Future<InfluencerListResponseEntity> getMyInfluencers(
    Map<String, dynamic> queryParams,
  ) async {
    final Response response = await remoteDataSource.getMyInfluencers(
      queryParams,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return InfluencerListResponseModel.fromJson(rawResponse).toEntity();
  }

  @override
  Future<ReferredUserLookupEntity?> searchUserByReferralCode(
    String code,
  ) async {
    final Response response = await remoteDataSource.searchUserByReferralCode(
      code,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return ReferredUserLookupModel.fromResponseJson(rawResponse)?.toEntity();
  }

  @override
  Future<void> requestInfluencerAssignment(Map<String, dynamic> payload) async {
    await remoteDataSource.requestInfluencerAssignment(payload);
  }
}

