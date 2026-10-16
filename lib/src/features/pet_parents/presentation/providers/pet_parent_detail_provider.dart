import 'package:flutter/material.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/pet_parent_entity.dart';
import '../../domain/usecases/pet_parents_usecases.dart';

class PetParentDetailProvider extends ChangeNotifier {
  final PetParentsUseCases useCases;

  PetParentDetailProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUpdatingPassword = false;
  bool get isUpdatingPassword => _isUpdatingPassword;

  bool _isUpdatingDetails = false;
  bool get isUpdatingDetails => _isUpdatingDetails;

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

  Future<bool> updatePassword({
    required BuildContext context,
    required String password,
    required String confirmPassword,
    String? petParentId,
  }) async {
    final targetId = petParentId ?? _currentId;
    if (targetId == null) return false;

    if (password.trim().isEmpty) {
      showToast(context, 'Password is required', isError: true);
      return false;
    }
    if (password != confirmPassword) {
      showToast(context, 'Passwords do not match', isError: true);
      return false;
    }

    _isUpdatingPassword = true;
    notifyListeners();

    try {
      final entity = UpdatePetParentPasswordEntity(
        password: password,
        confirmPassword: confirmPassword,
      );
      final response = await useCases.updatePetParentPassword(
        targetId,
        entity,
      );
      if (context.mounted) {
        showToast(
          context,
          response.message.isNotEmpty
              ? response.message
              : 'Password updated successfully',
        );
      }
      return response.success;
    } catch (e) {
      if (context.mounted) {
        showToast(
          context,
          e.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
      }
      return false;
    } finally {
      _isUpdatingPassword = false;
      notifyListeners();
    }
  }

  Future<bool> updateDetails({
    required BuildContext context,
    required UpdatePetParentEntity entity,
    String? petParentId,
  }) async {
    final targetId = petParentId ?? _currentId;
    if (targetId == null) return false;

    _isUpdatingDetails = true;
    notifyListeners();

    try {
      final response = await useCases.updatePetParent(targetId, entity);
      if (response.success && response.petParent != null) {
        _petParent = response.petParent;
      }
      if (context.mounted) {
        showToast(
          context,
          response.message.isNotEmpty
              ? response.message
              : 'Details updated successfully',
        );
      }
      return response.success;
    } catch (e) {
      if (context.mounted) {
        showToast(
          context,
          e.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
      }
      return false;
    } finally {
      _isUpdatingDetails = false;
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
