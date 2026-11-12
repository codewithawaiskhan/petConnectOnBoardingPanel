import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/company_dashboard_entity.dart';
import '../../domain/repositories/company_dashboard_repository.dart';
import '../data_sources/company_dashboard_remote_data_source.dart';
import '../models/company_dashboard_model.dart';

class CompanyDashboardRepositoryImpl implements CompanyDashboardRepository {
  final CompanyDashboardRemoteDataSource remoteDataSource;

  const CompanyDashboardRepositoryImpl({required this.remoteDataSource});

  Map<String, dynamic> _extractDoc(dynamic body) {
    final raw = body is Map<String, dynamic> ? body : <String, dynamic>{};
    final data = raw['data'];
    if (data is Map<String, dynamic>) {
      if (data['doc'] is Map<String, dynamic>) {
        return data['doc'] as Map<String, dynamic>;
      }
      return data;
    }
    if (raw['doc'] is Map<String, dynamic>) {
      return raw['doc'] as Map<String, dynamic>;
    }
    return raw;
  }

  @override
  Future<CompanyProfileEntity> getMyCompanyProfile() async {
    final Response response = await remoteDataSource.getMyCompanyProfile();
    final doc = _extractDoc(response.body);
    return CompanyProfileModel.fromJson(doc).toEntity();
  }

  @override
  Future<ReferralStatsEntity> getMyReferralStats({
    String? from,
    String? to,
  }) async {
    final Response response = await remoteDataSource.getMyReferralStats(
      from: from,
      to: to,
    );
    final doc = _extractDoc(response.body);
    return ReferralStatsModel.fromJson(doc).toEntity();
  }
}

