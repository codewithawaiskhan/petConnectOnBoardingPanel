import '../entities/redemption_entity.dart';
import '../repositories/company_redemptions_repository.dart';

class GetMyRedemptionsUseCase {
  final CompanyRedemptionsRepository repository;

  const GetMyRedemptionsUseCase({required this.repository});

  Future<RedemptionPaginatedEntity> call(Map<String, dynamic> queryParams) {
    return repository.getMyRedemptions(queryParams);
  }
}

class RequestPayPalRedemptionUseCase {
  final CompanyRedemptionsRepository repository;

  const RequestPayPalRedemptionUseCase({required this.repository});

  Future<RedemptionEntity> call(Map<String, dynamic> payload) {
    return repository.requestPayPalRedemption(payload);
  }
}

class CompanyRedemptionsUseCases {
  final CompanyRedemptionsRepository repository;

  const CompanyRedemptionsUseCases({required this.repository});

  Future<RedemptionPaginatedEntity> getMyRedemptions(
    Map<String, dynamic> queryParams,
  ) {
    return repository.getMyRedemptions(queryParams);
  }

  Future<RedemptionEntity> requestPayPalRedemption(
    Map<String, dynamic> payload,
  ) {
    return repository.requestPayPalRedemption(payload);
  }
}

