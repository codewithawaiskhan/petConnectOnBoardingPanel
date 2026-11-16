import 'package:flutter/material.dart';
import '../../../../core/utils/show_toast.dart';
import '../../data/models/settings_model.dart';
import '../../domain/usecases/admin_settings_usecases.dart';

class AdminSettingsProvider extends ChangeNotifier {
  final AdminSettingsUseCases useCases;

  AdminSettingsProvider({required this.useCases});

  SettingsModel? _settings;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  SettingsModel? get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSettings([BuildContext? context]) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final entity = await useCases.getSettings();
      _settings = SettingsModel.fromEntity(entity);
    } catch (e) {
      _errorMessage = e.toString();
      if (context != null && context.mounted) {
        showToast(context, 'Failed to load settings: $e', isError: true);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateSettings({
    required bool isReferralEnabled,
    required double payoutAmount,
    required double minRedeemAmount,
    BuildContext? context,
  }) async {
    _isSaving = true;
    notifyListeners();

    final payload = <String, dynamic>{
      'isReferralSystemEnabled': isReferralEnabled,
      'payoutThreshold': {
        'amount': payoutAmount,
        'currencyCode': 'USD',
      },
      'minimumRedeemable': {
        'amount': minRedeemAmount,
        'currencyCode': 'USD',
      },
    };

    try {
      final updatedEntity = await useCases.updateSettings(payload);
      _settings = SettingsModel.fromEntity(updatedEntity);
      if (context != null && context.mounted) {
        showToast(context, 'Settings updated successfully');
      }
      await fetchSettings();
      return true;
    } catch (e) {
      if (context != null && context.mounted) {
        showToast(context, 'Failed to update settings: $e', isError: true);
      }
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
