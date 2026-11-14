import '../../../company_redemptions/domain/entities/redemption_entity.dart';
import '../repositories/company_payouts_repository.dart';

class CompanyPayoutsUseCases {
  final CompanyPayoutsRepository repository;

  const CompanyPayoutsUseCases({required this.repository});

  Future<RedemptionPaginatedEntity> getAllPayouts(
    Map<String, dynamic> queryParams,
  ) {
    return repository.getAllPayouts(queryParams);
  }

  Future<void> updatePayoutStatus({
    required String id,
    required String status,
    String? failedReason,
  }) {
    return repository.updatePayoutStatus(
      id: id,
      status: status,
      failedReason: failedReason,
    );
  }
}

