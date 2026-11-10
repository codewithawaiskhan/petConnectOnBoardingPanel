import '../entities/withdrawal_request_entity.dart';
import '../repositories/withdrawal_repository.dart';

class GetWithdrawalRequestsUseCase {
  final WithdrawalRepository repository;

  const GetWithdrawalRequestsUseCase({required this.repository});

  Future<WithdrawalListResponseEntity> call(
    Map<String, dynamic> queryParams,
  ) {
    return repository.getWithdrawalRequests(queryParams);
  }
}

class UpdateWithdrawalStatusUseCase {
  final WithdrawalRepository repository;

  const UpdateWithdrawalStatusUseCase({required this.repository});

  Future<WithdrawalRequestEntity?> call({
    required String id,
    required String status,
    String? failedReason,
  }) {
    return repository.updateWithdrawalStatus(
      id: id,
      status: status,
      failedReason: failedReason,
    );
  }
}
