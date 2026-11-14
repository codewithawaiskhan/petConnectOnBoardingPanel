import '../entities/commission_ledger_entry_entity.dart';
import '../entities/referral_balance_entity.dart';
import '../repositories/company_wallet_repository.dart';

class GetMyReferralBalanceUseCase {
  final CompanyWalletRepository repository;

  const GetMyReferralBalanceUseCase({required this.repository});

  Future<ReferralBalanceEntity> call() {
    return repository.getMyReferralBalance();
  }
}

class GetMyCommissionLedgerUseCase {
  final CompanyWalletRepository repository;

  const GetMyCommissionLedgerUseCase({required this.repository});

  Future<CommissionLedgerPaginatedEntity> call(
    Map<String, dynamic> queryParams,
  ) {
    return repository.getMyCommissionLedger(queryParams);
  }
}

class CompanyWalletUseCases {
  final CompanyWalletRepository repository;

  const CompanyWalletUseCases({required this.repository});

  Future<ReferralBalanceEntity> getMyReferralBalance() {
    return repository.getMyReferralBalance();
  }

  Future<CommissionLedgerPaginatedEntity> getMyCommissionLedger(
    Map<String, dynamic> queryParams,
  ) {
    return repository.getMyCommissionLedger(queryParams);
  }
}

