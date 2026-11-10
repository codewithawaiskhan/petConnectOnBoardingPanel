import '../entities/withdrawal_request_entity.dart';

abstract class WithdrawalRepository {
  Future<WithdrawalListResponseEntity> getWithdrawalRequests(
    Map<String, dynamic> queryParams,
  );

  Future<WithdrawalRequestEntity?> updateWithdrawalStatus({
    required String id,
    required String status,
    String? failedReason,
  });
}
