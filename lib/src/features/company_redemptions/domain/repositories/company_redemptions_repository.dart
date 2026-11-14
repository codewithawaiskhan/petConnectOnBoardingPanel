import '../entities/redemption_entity.dart';

abstract class CompanyRedemptionsRepository {
  Future<RedemptionPaginatedEntity> getMyRedemptions(
    Map<String, dynamic> queryParams,
  );
  Future<RedemptionEntity> requestPayPalRedemption(
    Map<String, dynamic> payload,
  );
}

