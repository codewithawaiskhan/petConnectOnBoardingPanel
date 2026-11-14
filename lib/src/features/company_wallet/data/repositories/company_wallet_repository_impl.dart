import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/commission_ledger_entry_entity.dart';
import '../../domain/entities/referral_balance_entity.dart';
import '../../domain/repositories/company_wallet_repository.dart';
import '../data_sources/company_wallet_remote_data_source.dart';
import '../models/commission_ledger_entry_model.dart';
import '../models/referral_balance_model.dart';

class CompanyWalletRepositoryImpl implements CompanyWalletRepository {
  final CompanyWalletRemoteDataSource remoteDataSource;

  const CompanyWalletRepositoryImpl({required this.remoteDataSource});

  Map<String, dynamic> _extractDoc(dynamic body) {
    final raw = body is Map<String, dynamic> ? body : <String, dynamic>{};
    final data = raw['data'];
    if (data is Map<String, dynamic>) {
      if (data['doc'] is Map<String, dynamic>) {
        return data['doc'] as Map<String, dynamic>;
      }
      return data;
    }
    if (raw['doc'] is Map<String, dynamic>) {
      return raw['doc'] as Map<String, dynamic>;
    }
    return raw;
  }

  Map<String, dynamic> _extractData(dynamic body) {
    final raw = body is Map<String, dynamic> ? body : <String, dynamic>{};
    final data = raw['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return raw;
  }

  @override
  Future<ReferralBalanceEntity> getMyReferralBalance() async {
    final Response response = await remoteDataSource.getMyReferralBalance();
    final doc = _extractDoc(response.body);
    return ReferralBalanceModel.fromJson(doc).toEntity();
  }

  @override
  Future<CommissionLedgerPaginatedEntity> getMyCommissionLedger(
    Map<String, dynamic> queryParams,
  ) async {
    final Response response = await remoteDataSource.getMyCommissionLedger(
      queryParams,
    );
    final data = _extractData(response.body);
    return CommissionLedgerPaginatedModel.fromJson(data).toEntity();
  }
}

