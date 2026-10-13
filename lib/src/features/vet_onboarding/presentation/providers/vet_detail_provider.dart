import 'package:flutter/material.dart';
import '../../domain/entities/doctor_list_entity.dart';
import '../../domain/usecases/vet_onboarding_usecases.dart';

class VetDetailProvider extends ChangeNotifier {
  final VetOnboardingUseCases useCases;

  VetDetailProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DoctorItemEntity? _doctor;
  DoctorItemEntity? get doctor => _doctor;

  String? _currentDoctorId;
  String? get currentDoctorId => _currentDoctorId;

  Future<void> fetchDoctorDetail(String id, {bool forceRefresh = false}) async {
    if (!forceRefresh && _currentDoctorId == id && _doctor != null) {
      return;
    }

    _currentDoctorId = id;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await useCases.getDoctorDetail(id);
      _doctor = response.doctor;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _doctor = null;
    _currentDoctorId = null;
    _errorMessage = null;
    _isLoading = false;
  }
}
