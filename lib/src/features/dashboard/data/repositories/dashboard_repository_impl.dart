import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/dashboard_remote_data_source.dart';
import '../models/dashboard_stats_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  const DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardStatsResponseEntity> getAdminDashboardData() async {
    final Response response = await remoteDataSource.getAdminDashboardData();

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return DashboardStatsResponseModel.fromJson(rawResponse);
  }
}
