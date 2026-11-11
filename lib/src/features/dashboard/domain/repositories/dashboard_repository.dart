import '../entities/dashboard_stats_entity.dart';
import '../entities/top_countries_entity.dart';

abstract class DashboardRepository {
  Future<DashboardStatsResponseEntity> getAdminDashboardData({
    String? from,
    String? to,
  });
  Future<TopCountriesResponseEntity> getTopCountries({
    String? countryCode,
    String? from,
    String? to,
  });
}
