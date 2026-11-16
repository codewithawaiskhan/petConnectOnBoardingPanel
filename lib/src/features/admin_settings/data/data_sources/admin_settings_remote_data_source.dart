import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class AdminSettingsRemoteDataSource {
  Future<Response> getSettings();
  Future<Response> updateSettings(Map<String, dynamic> payload);
}

class AdminSettingsRemoteDataSourceImpl
    implements AdminSettingsRemoteDataSource {
  final ApiServices apiServices;

  const AdminSettingsRemoteDataSourceImpl({required this.apiServices});

  String get _settingsUri =>
      '${ApiEndpoints.apiUrl}${ApiEndpoints.globalSettings}';

  @override
  Future<Response> getSettings() {
    return apiServices.getData(_settingsUri);
  }

  @override
  Future<Response> updateSettings(Map<String, dynamic> payload) {
    return apiServices.postData(_settingsUri, payload);
  }
}
