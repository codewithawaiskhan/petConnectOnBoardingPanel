import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class CommissionSettingsRemoteDataSource {
  Future<Response> getCompanyPolicies(Map<String, dynamic> queryParams);
  Future<Response> createCompanyPolicy(Map<String, dynamic> payload);
  Future<Response> getGlobalSettings(Map<String, dynamic> queryParams);
  Future<Response> createGlobalSettings(Map<String, dynamic> payload);
}

class CommissionSettingsRemoteDataSourceImpl
    implements CommissionSettingsRemoteDataSource {
  final ApiServices apiServices;

  const CommissionSettingsRemoteDataSourceImpl({required this.apiServices});

  String get _companyPolicyUri =>
      '${ApiEndpoints.apiUrl}${ApiEndpoints.companyCommissionPolicy}';

  String get _globalSettingsUri =>
      '${ApiEndpoints.apiUrl}${ApiEndpoints.renewalCommissionSettings}';

  Map<String, String> _sanitize(Map<String, dynamic> queryParams) {
    final sanitized = <String, String>{};
    queryParams.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        sanitized[key] = value.toString().trim();
      }
    });
    return sanitized;
  }

  @override
  Future<Response> getCompanyPolicies(Map<String, dynamic> queryParams) {
    final sanitized = _sanitize(queryParams);
    final uri = Uri.parse(_companyPolicyUri)
        .replace(queryParameters: sanitized.isEmpty ? null : sanitized)
        .toString();
    return apiServices.getData(uri);
  }

  @override
  Future<Response> createCompanyPolicy(Map<String, dynamic> payload) {
    return apiServices.postData(_companyPolicyUri, payload);
  }

  @override
  Future<Response> getGlobalSettings(Map<String, dynamic> queryParams) {
    final sanitized = _sanitize(queryParams);
    final uri = Uri.parse(_globalSettingsUri)
        .replace(queryParameters: sanitized.isEmpty ? null : sanitized)
        .toString();
    return apiServices.getData(uri);
  }

  @override
  Future<Response> createGlobalSettings(Map<String, dynamic> payload) {
    return apiServices.postData(_globalSettingsUri, payload);
  }
}

