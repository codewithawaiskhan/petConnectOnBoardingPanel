import '../entities/dashboard_stats_entity.dart';
import '../entities/top_countries_entity.dart';
import '../repositories/dashboard_repository.dart';

class DashboardUseCases {
  final DashboardRepository repository;

  const DashboardUseCases({required this.repository});

  Future<DashboardStatsResponseEntity> getAdminDashboardData({
    String? from,
    String? to,
  }) async {
    return await repository.getAdminDashboardData(from: from, to: to);
  }

  Future<TopCountriesResponseEntity> getTopCountries({
    String? countryCode,
    String? from,
    String? to,
  }) async {
    return await repository.getTopCountries(
      countryCode: countryCode,
      from: from,
      to: to,
    );
  }
}
