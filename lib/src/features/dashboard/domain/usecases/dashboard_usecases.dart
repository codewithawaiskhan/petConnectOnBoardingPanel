import '../entities/dashboard_stats_entity.dart';
import '../repositories/dashboard_repository.dart';

class DashboardUseCases {
  final DashboardRepository repository;

  const DashboardUseCases({required this.repository});

  Future<DashboardStatsResponseEntity> getAdminDashboardData() async {
    return await repository.getAdminDashboardData();
  }
}
