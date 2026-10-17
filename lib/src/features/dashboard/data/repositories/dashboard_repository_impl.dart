import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/entities/top_countries_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../data_sources/dashboard_remote_data_source.dart';
import '../models/dashboard_stats_model.dart';
import '../models/top_countries_model.dart';

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

  @override
  Future<TopCountriesResponseEntity> getTopCountries({String? countryCode}) async {
    final Response response = await remoteDataSource.getTopCountries(
      countryCode: countryCode,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return TopCountriesResponseModel.fromJson(rawResponse);
  }
}
