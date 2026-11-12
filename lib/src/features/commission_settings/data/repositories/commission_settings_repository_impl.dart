import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/commission_settings_entity.dart';
import '../../domain/repositories/commission_settings_repository.dart';
import '../data_sources/commission_settings_remote_data_source.dart';
import '../models/company_commission_policy_model.dart';
import '../models/renewal_commission_settings_model.dart';

class CommissionSettingsRepositoryImpl implements CommissionSettingsRepository {
  final CommissionSettingsRemoteDataSource remoteDataSource;

  const CommissionSettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CompanyCommissionPolicyListResponseEntity> getCompanyPolicies(
    Map<String, dynamic> queryParams,
  ) async {
    final Response response = await remoteDataSource.getCompanyPolicies(
      queryParams,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return CompanyCommissionPolicyListResponseModel.fromJson(
      rawResponse,
    ).toEntity();
  }

  @override
  Future<CompanyCommissionPolicyEntity?> createCompanyPolicy(
    Map<String, dynamic> payload,
  ) async {
    final Response response = await remoteDataSource.createCompanyPolicy(
      payload,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data['doc'] is Map<String, dynamic>) {
        return CompanyCommissionPolicyModel.fromJson(
          data['doc'] as Map<String, dynamic>,
        ).toEntity();
      }
      if (data.containsKey('_id') || data.containsKey('id')) {
        return CompanyCommissionPolicyModel.fromJson(data).toEntity();
      }
    }
    return null;
  }

  @override
  Future<RenewalCommissionSettingsListResponseEntity> getGlobalSettings(
    Map<String, dynamic> queryParams,
  ) async {
    final Response response = await remoteDataSource.getGlobalSettings(
      queryParams,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return RenewalCommissionSettingsListResponseModel.fromJson(
      rawResponse,
    ).toEntity();
  }

  @override
  Future<RenewalCommissionSettingsEntity?> createGlobalSettings(
    Map<String, dynamic> payload,
  ) async {
    final Response response = await remoteDataSource.createGlobalSettings(
      payload,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data['doc'] is Map<String, dynamic>) {
        return RenewalCommissionSettingsModel.fromJson(
          data['doc'] as Map<String, dynamic>,
        ).toEntity();
      }
      if (data.containsKey('_id') || data.containsKey('id')) {
        return RenewalCommissionSettingsModel.fromJson(data).toEntity();
      }
    }
    return null;
  }
}

