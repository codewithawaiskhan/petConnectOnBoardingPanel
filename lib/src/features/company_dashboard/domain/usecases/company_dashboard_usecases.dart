import '../entities/company_dashboard_entity.dart';
import '../repositories/company_dashboard_repository.dart';

class GetCompanyDashboardUseCase {
  final CompanyDashboardRepository repository;

  const GetCompanyDashboardUseCase({required this.repository});

  Future<CompanyDashboardEntity> call({String? from, String? to}) {
    return repository.getMyCompanyDashboard(from: from, to: to);
  }
}
