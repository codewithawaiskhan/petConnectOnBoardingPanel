import 'package:flutter/material.dart';
import '../../domain/entities/service_provider_list_entity.dart';
import '../../domain/usecases/service_provider_onboarding_usecases.dart';

class ServiceProviderDetailProvider extends ChangeNotifier {
  final ServiceProviderOnboardingUseCases useCases;

  ServiceProviderDetailProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ServiceProviderItemEntity? _serviceProvider;
  ServiceProviderItemEntity? get serviceProvider => _serviceProvider;

  String? _currentProviderId;
  String? get currentProviderId => _currentProviderId;

  Future<void> fetchServiceProviderDetail(
    String id, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _currentProviderId == id && _serviceProvider != null) {
      return;
    }

    _currentProviderId = id;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await useCases.getServiceProviderDetail(id);
      _serviceProvider = response.serviceProvider;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _serviceProvider = null;
    _currentProviderId = null;
    _errorMessage = null;
    _isLoading = false;
  }
}
