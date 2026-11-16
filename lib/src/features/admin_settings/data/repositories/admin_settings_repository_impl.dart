import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/admin_settings_repository.dart';
import '../data_sources/admin_settings_remote_data_source.dart';
import '../models/settings_model.dart';

class AdminSettingsRepositoryImpl implements AdminSettingsRepository {
  final AdminSettingsRemoteDataSource remoteDataSource;

  const AdminSettingsRepositoryImpl({required this.remoteDataSource});

  Map<String, dynamic> _extractData(Response response) {
    if (response.body is Map<String, dynamic>) {
      final body = response.body as Map<String, dynamic>;
      final data = body['data'];
      if (data is Map<String, dynamic>) {
        if (data['doc'] is Map<String, dynamic>) {
          return data['doc'] as Map<String, dynamic>;
        }
        if (data['settings'] is Map<String, dynamic>) {
          return data['settings'] as Map<String, dynamic>;
        }
        return data;
      }
      return body;
    }
    return <String, dynamic>{};
  }

  @override
  Future<SettingsEntity> getSettings() async {
    final response = await remoteDataSource.getSettings();
    final json = _extractData(response);
    return SettingsModel.fromJson(json).toEntity();
  }

  @override
  Future<SettingsEntity> updateSettings(Map<String, dynamic> payload) async {
    final response = await remoteDataSource.updateSettings(payload);
    final json = _extractData(response);
    return SettingsModel.fromJson(json).toEntity();
  }
}
