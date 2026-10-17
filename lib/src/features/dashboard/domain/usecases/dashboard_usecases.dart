import '../entities/dashboard_stats_entity.dart';
import '../entities/top_countries_entity.dart';
import '../repositories/dashboard_repository.dart';

class DashboardUseCases {
  final DashboardRepository repository;

  const DashboardUseCases({required this.repository});

  Future<DashboardStatsResponseEntity> getAdminDashboardData() async {
    return await repository.getAdminDashboardData();
  }

  Future<TopCountriesResponseEntity> getTopCountries({String? countryCode}) async {
    return await repository.getTopCountries(countryCode: countryCode);
  }
}
