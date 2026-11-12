import '../entities/company_dashboard_entity.dart';
import '../repositories/company_dashboard_repository.dart';

class GetMyCompanyProfileUseCase {
  final CompanyDashboardRepository repository;

  const GetMyCompanyProfileUseCase({required this.repository});

  Future<CompanyProfileEntity> call() {
    return repository.getMyCompanyProfile();
  }
}

class GetMyReferralStatsUseCase {
  final CompanyDashboardRepository repository;

  const GetMyReferralStatsUseCase({required this.repository});

  Future<ReferralStatsEntity> call({String? from, String? to}) {
    return repository.getMyReferralStats(from: from, to: to);
  }
}

