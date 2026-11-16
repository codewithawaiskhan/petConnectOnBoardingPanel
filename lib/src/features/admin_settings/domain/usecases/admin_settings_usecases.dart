import '../entities/settings_entity.dart';
import '../repositories/admin_settings_repository.dart';

class AdminSettingsUseCases {
  final AdminSettingsRepository repository;

  const AdminSettingsUseCases({required this.repository});

  Future<SettingsEntity> getSettings() {
    return repository.getSettings();
  }

  Future<SettingsEntity> updateSettings(Map<String, dynamic> payload) {
    return repository.updateSettings(payload);
  }
}

class GetSettingsUseCase {
  final AdminSettingsUseCases useCases;
  const GetSettingsUseCase(this.useCases);
  Future<SettingsEntity> call() => useCases.getSettings();
}

class UpdateSettingsUseCase {
  final AdminSettingsUseCases useCases;
  const UpdateSettingsUseCase(this.useCases);
  Future<SettingsEntity> call(Map<String, dynamic> payload) =>
      useCases.updateSettings(payload);
}
