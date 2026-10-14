import 'package:flutter/material.dart';
import '../../domain/entities/pet_parent_entity.dart';
import '../../domain/usecases/pet_parents_usecases.dart';

class PetParentDetailProvider extends ChangeNotifier {
  final PetParentsUseCases useCases;

  PetParentDetailProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PetParentItemEntity? _petParent;
  PetParentItemEntity? get petParent => _petParent;

  String? _currentId;
  String? get currentId => _currentId;

  Future<void> fetchPetParentDetail(
    String id, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _currentId == id && _petParent != null) {
      return;
    }

    _currentId = id;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await useCases.getPetParentDetail(id);
      _petParent = response.petParent;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _petParent = null;
    _currentId = null;
    _errorMessage = null;
    _isLoading = false;
  }
}
