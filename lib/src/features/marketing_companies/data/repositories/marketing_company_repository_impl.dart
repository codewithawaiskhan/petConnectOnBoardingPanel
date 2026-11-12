import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/marketing_company_entity.dart';
import '../../domain/repositories/marketing_company_repository.dart';
import '../data_sources/marketing_company_remote_data_source.dart';
import '../models/marketing_company_model.dart';

class MarketingCompanyRepositoryImpl implements MarketingCompanyRepository {
  final MarketingCompanyRemoteDataSource remoteDataSource;

  const MarketingCompanyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MarketingCompanyListResponseEntity> getCompanies(
    Map<String, dynamic> queryParams,
  ) async {
    final Response response = await remoteDataSource.getCompanies(queryParams);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return MarketingCompanyListResponseModel.fromJson(rawResponse).toEntity();
  }

  @override
  Future<MarketingCompanyEntity?> createCompany(
    Map<String, dynamic> payload,
  ) async {
    final Response response = await remoteDataSource.createCompany(payload);
    return _parseSingleCompany(response.body);
  }

  @override
  Future<MarketingCompanyEntity?> updateCompany(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final Response response = await remoteDataSource.updateCompany(id, payload);
    return _parseSingleCompany(response.body);
  }

  @override
  Future<void> deleteCompany(String id) async {
    await remoteDataSource.deleteCompany(id);
  }

  MarketingCompanyEntity? _parseSingleCompany(dynamic body) {
    final Map<String, dynamic> rawResponse = body is Map<String, dynamic>
        ? body
        : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data['doc'] is Map<String, dynamic>) {
        return MarketingCompanyModel.fromJson(
          data['doc'] as Map<String, dynamic>,
        ).toEntity();
      }
      if (data.containsKey('_id') || data.containsKey('id')) {
        return MarketingCompanyModel.fromJson(data).toEntity();
      }
    } else if (rawResponse.containsKey('_id') || rawResponse.containsKey('id')) {
      return MarketingCompanyModel.fromJson(rawResponse).toEntity();
    }

    return null;
  }
}

