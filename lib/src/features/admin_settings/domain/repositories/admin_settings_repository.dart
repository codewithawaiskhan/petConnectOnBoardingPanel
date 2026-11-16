import '../entities/settings_entity.dart';

abstract class AdminSettingsRepository {
  Future<SettingsEntity> getSettings();
  Future<SettingsEntity> updateSettings(Map<String, dynamic> payload);
}
