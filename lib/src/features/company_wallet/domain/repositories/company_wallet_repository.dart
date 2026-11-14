import '../entities/commission_ledger_entry_entity.dart';
import '../entities/referral_balance_entity.dart';

abstract class CompanyWalletRepository {
  Future<ReferralBalanceEntity> getMyReferralBalance();
  Future<CommissionLedgerPaginatedEntity> getMyCommissionLedger(
    Map<String, dynamic> queryParams,
  );
}

