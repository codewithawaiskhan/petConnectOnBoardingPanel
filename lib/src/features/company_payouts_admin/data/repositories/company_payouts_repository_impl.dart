import '../../../../core/network/models/response/response.dart';
import '../../../company_redemptions/data/models/redemption_model.dart';
import '../../../company_redemptions/domain/entities/redemption_entity.dart';
import '../../domain/repositories/company_payouts_repository.dart';
import '../data_sources/company_payouts_remote_data_source.dart';

class CompanyPayoutsRepositoryImpl implements CompanyPayoutsRepository {
  final CompanyPayoutsRemoteDataSource remoteDataSource;

  const CompanyPayoutsRepositoryImpl({required this.remoteDataSource});

  Map<String, dynamic> _extractData(dynamic body) {
    final raw = body is Map<String, dynamic> ? body : <String, dynamic>{};
    final data = raw['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return raw;
  }

  @override
  Future<RedemptionPaginatedEntity> getAllPayouts(
    Map<String, dynamic> queryParams,
  ) async {
    final Response response = await remoteDataSource.getAllPayouts(
      queryParams,
    );
    final data = _extractData(response.body);
    return RedemptionPaginatedModel.fromJson(data).toEntity();
  }

  @override
  Future<void> updatePayoutStatus({
    required String id,
    required String status,
    String? failedReason,
  }) async {
    final payload = <String, dynamic>{'status': status};
    if (failedReason != null && failedReason.trim().isNotEmpty) {
      payload['failedReason'] = failedReason.trim();
    }
    await remoteDataSource.updatePayoutStatus(id, payload);
  }
}

