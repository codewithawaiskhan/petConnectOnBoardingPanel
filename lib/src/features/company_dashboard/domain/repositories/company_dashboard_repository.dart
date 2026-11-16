import '../entities/company_dashboard_entity.dart';

abstract class CompanyDashboardRepository {
  Future<CompanyDashboardEntity> getMyCompanyDashboard({String? from, String? to});
}
