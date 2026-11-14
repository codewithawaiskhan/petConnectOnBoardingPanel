import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/redemption_entity.dart';
import '../../domain/repositories/company_redemptions_repository.dart';
import '../data_sources/company_redemptions_remote_data_source.dart';
import '../models/redemption_model.dart';

class CompanyRedemptionsRepositoryImpl implements CompanyRedemptionsRepository {
  final CompanyRedemptionsRemoteDataSource remoteDataSource;

  const CompanyRedemptionsRepositoryImpl({required this.remoteDataSource});

  Map<String, dynamic> _extractDoc(dynamic body) {
    final raw = body is Map<String, dynamic> ? body : <String, dynamic>{};
    final data = raw['data'];
    if (data is Map<String, dynamic>) {
      if (data['doc'] is Map<String, dynamic>) {
        return data['doc'] as Map<String, dynamic>;
      }
      return data;
    }
    if (raw['doc'] is Map<String, dynamic>) {
      return raw['doc'] as Map<String, dynamic>;
    }
    return raw;
  }

  Map<String, dynamic> _extractData(dynamic body) {
    final raw = body is Map<String, dynamic> ? body : <String, dynamic>{};
    final data = raw['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return raw;
  }

  @override
  Future<RedemptionPaginatedEntity> getMyRedemptions(
    Map<String, dynamic> queryParams,
  ) async {
    final Response response = await remoteDataSource.getMyRedemptions(
      queryParams,
    );
    final data = _extractData(response.body);
    return RedemptionPaginatedModel.fromJson(data).toEntity();
  }

  @override
  Future<RedemptionEntity> requestPayPalRedemption(
    Map<String, dynamic> payload,
  ) async {
    final Response response = await remoteDataSource.requestPayPalRedemption(
      payload,
    );
    final doc = _extractDoc(response.body);
    return RedemptionModel.fromJson(doc).toEntity();
  }
}

