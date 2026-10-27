import 'package:flutter/material.dart';
import '../../domain/entities/medical_record_entity.dart';
import '../../domain/usecases/medical_records_usecases.dart';

class MedicalRecordsProvider extends ChangeNotifier {
  final MedicalRecordsUseCases useCases;

  MedicalRecordsProvider({required this.useCases});

  bool _isRecordsLoading = false;
  bool get isRecordsLoading => _isRecordsLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<MedicalRecordEntity> _records = const [];
  List<MedicalRecordEntity> get records => _records;

  String? _currentUserId;
  String? get currentUserId => _currentUserId;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String _selectedPetId = 'All';
  String get selectedPetId => _selectedPetId;

  List<String> get availableCategories {
    final Set<String> categories = {'All'};
    for (final record in _records) {
      if (record.category.isNotEmpty) {
        categories.add(record.category);
      }
    }
    return categories.toList();
  }

  List<MedicalRecordEntity> get filteredRecords {
    return _records.where((record) {
      final matchesCategory = _selectedCategory == 'All' ||
          record.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesPet = _selectedPetId == 'All' ||
          (record.pet?.id != null && record.pet!.id == _selectedPetId);
      return matchesCategory && matchesPet;
    }).toList();
  }

  void setSelectedCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void setSelectedPetId(String petId) {
    if (_selectedPetId != petId) {
      _selectedPetId = petId;
      notifyListeners();
    }
  }

  Future<void> fetchMedicalRecords(
    String userId, {
    bool forceRefresh = false,
  }) async {
    if (userId.isEmpty) return;

    if (!forceRefresh && _currentUserId == userId && _records.isNotEmpty) {
      return;
    }

    _currentUserId = userId;
    _isRecordsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await useCases.getMedicalRecordsByUserId(userId);
      _records = results;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isRecordsLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _records = const [];
    _currentUserId = null;
    _errorMessage = null;
    _selectedCategory = 'All';
    _selectedPetId = 'All';
    _isRecordsLoading = false;
  }
}
