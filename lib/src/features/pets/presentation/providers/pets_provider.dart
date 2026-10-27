import 'package:flutter/material.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/usecases/get_pets_by_parent_id_usecase.dart';

class PetsProvider extends ChangeNotifier {
  final GetPetsByParentIdUseCase getPetsByParentIdUseCase;

  PetsProvider({required this.getPetsByParentIdUseCase});

  bool _isPetsLoading = false;
  bool get isPetsLoading => _isPetsLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<PetEntity> _pets = [];
  List<PetEntity> get pets => _pets;

  String? _currentParentId;
  String? get currentParentId => _currentParentId;

  Future<void> fetchPets(
    String parentId, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _currentParentId == parentId && _pets.isNotEmpty) {
      return;
    }

    _currentParentId = parentId;
    _isPetsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pets = await getPetsByParentIdUseCase(parentId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isPetsLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _pets = [];
    _currentParentId = null;
    _errorMessage = null;
    _isPetsLoading = false;
    notifyListeners();
  }
}
