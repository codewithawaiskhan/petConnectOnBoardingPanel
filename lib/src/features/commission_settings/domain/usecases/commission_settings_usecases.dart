import '../entities/commission_settings_entity.dart';
import '../repositories/commission_settings_repository.dart';

class GetCompanyCommissionPoliciesUseCase {
  final CommissionSettingsRepository repository;

  const GetCompanyCommissionPoliciesUseCase({required this.repository});

  Future<CompanyCommissionPolicyListResponseEntity> call(
    Map<String, dynamic> queryParams,
  ) {
    return repository.getCompanyPolicies(queryParams);
  }
}

class CreateCompanyCommissionPolicyUseCase {
  final CommissionSettingsRepository repository;

  const CreateCompanyCommissionPolicyUseCase({required this.repository});

  Future<CompanyCommissionPolicyEntity?> call(Map<String, dynamic> payload) {
    return repository.createCompanyPolicy(payload);
  }
}

class GetRenewalCommissionSettingsUseCase {
  final CommissionSettingsRepository repository;

  const GetRenewalCommissionSettingsUseCase({required this.repository});

  Future<RenewalCommissionSettingsListResponseEntity> call(
    Map<String, dynamic> queryParams,
  ) {
    return repository.getGlobalSettings(queryParams);
  }
}

class CreateRenewalCommissionSettingsUseCase {
  final CommissionSettingsRepository repository;

  const CreateRenewalCommissionSettingsUseCase({required this.repository});

  Future<RenewalCommissionSettingsEntity?> call(Map<String, dynamic> payload) {
    return repository.createGlobalSettings(payload);
  }
}

