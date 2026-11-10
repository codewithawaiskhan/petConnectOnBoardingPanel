import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../../domain/repositories/withdrawal_repository.dart';
import '../data_sources/withdrawal_remote_data_source.dart';
import '../models/withdrawal_request_model.dart';

class WithdrawalRepositoryImpl implements WithdrawalRepository {
  final WithdrawalRemoteDataSource remoteDataSource;

  const WithdrawalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<WithdrawalListResponseEntity> getWithdrawalRequests(
    Map<String, dynamic> queryParams,
  ) async {
    final Response response = await remoteDataSource.getWithdrawalRequests(
      queryParams,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return WithdrawalListResponseModel.fromJson(rawResponse).toEntity();
  }

  @override
  Future<WithdrawalRequestEntity?> updateWithdrawalStatus({
    required String id,
    required String status,
    String? failedReason,
  }) async {
    final payload = <String, dynamic>{
      'status': status,
      if (status == 'Failed' &&
          failedReason != null &&
          failedReason.trim().isNotEmpty)
        'failedReason': failedReason.trim(),
    };

    final Response response = await remoteDataSource.updateStatus(id, payload);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data['doc'] is Map<String, dynamic>) {
        return WithdrawalRequestModel.fromJson(
          data['doc'] as Map<String, dynamic>,
        ).toEntity();
      }
      if (data.containsKey('_id') || data.containsKey('id')) {
        return WithdrawalRequestModel.fromJson(data).toEntity();
      }
    } else if (rawResponse.containsKey('_id') || rawResponse.containsKey('id')) {
      return WithdrawalRequestModel.fromJson(rawResponse).toEntity();
    }

    return null;
  }
}
