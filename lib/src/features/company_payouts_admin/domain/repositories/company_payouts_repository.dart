import '../../../company_redemptions/domain/entities/redemption_entity.dart';

abstract class CompanyPayoutsRepository {
  Future<RedemptionPaginatedEntity> getAllPayouts(
    Map<String, dynamic> queryParams,
  );

  Future<void> updatePayoutStatus({
    required String id,
    required String status,
    String? failedReason,
  });
}

