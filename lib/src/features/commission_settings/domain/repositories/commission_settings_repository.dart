import '../entities/commission_settings_entity.dart';

abstract class CommissionSettingsRepository {
  Future<CompanyCommissionPolicyListResponseEntity> getCompanyPolicies(
    Map<String, dynamic> queryParams,
  );

  Future<CompanyCommissionPolicyEntity?> createCompanyPolicy(
    Map<String, dynamic> payload,
  );

  Future<RenewalCommissionSettingsListResponseEntity> getGlobalSettings(
    Map<String, dynamic> queryParams,
  );

  Future<RenewalCommissionSettingsEntity?> createGlobalSettings(
    Map<String, dynamic> payload,
  );
}

