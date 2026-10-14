import 'package:flutter/material.dart';
import '../../domain/entities/lab_entity.dart';
import '../../domain/usecases/lab_onboarding_usecases.dart';

class LabDetailProvider extends ChangeNotifier {
  final LabOnboardingUseCases useCases;

  LabDetailProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LabItemEntity? _lab;
  LabItemEntity? get lab => _lab;

  String? _currentLabId;
  String? get currentLabId => _currentLabId;

  Future<void> fetchLabDetail(String id, {bool forceRefresh = false}) async {
    if (!forceRefresh && _currentLabId == id && _lab != null) {
      return;
    }

    _currentLabId = id;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await useCases.getLabDetail(id);
      _lab = response.lab;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _lab = null;
    _currentLabId = null;
    _errorMessage = null;
    _isLoading = false;
  }
}
