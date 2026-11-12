import '../entities/company_dashboard_entity.dart';

abstract class CompanyDashboardRepository {
  Future<CompanyProfileEntity> getMyCompanyProfile();
  Future<ReferralStatsEntity> getMyReferralStats({String? from, String? to});
}

