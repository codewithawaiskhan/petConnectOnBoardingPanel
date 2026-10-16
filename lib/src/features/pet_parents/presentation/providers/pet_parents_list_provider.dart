import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/pet_parent_entity.dart';
import '../../domain/usecases/pet_parents_usecases.dart';

class PetParentsListProvider extends ChangeNotifier {
  final PetParentsUseCases useCases;

  PetParentsListProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<PetParentItemEntity> _petParents = [];
  List<PetParentItemEntity> get petParents => _petParents;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalDocs = 0;
  int get totalDocs => _totalDocs;

  int _limit = 10;
  int get limit => _limit;
  int get pageSize => _limit;

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchPetParents(isRefresh: true);
  }

  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  Future<void> fetchPetParents({bool isRefresh = false, int? page}) async {
    final targetPage = page ?? (isRefresh ? 1 : _currentPage);

    if (isRefresh || targetPage == 1) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    } else {
      _isPaginationLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final response = await useCases.getPetParents(
        page: targetPage,
        pageSize: _limit,
        keyword: _searchKeyword.trim().isEmpty ? null : _searchKeyword.trim(),
      );

      _petParents = response.docs;
      _currentPage = targetPage;
      _totalPages = response.pages > 0 ? response.pages : 1;
      _totalDocs = response.docsCount >= 0 ? response.docsCount : _petParents.length;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      _isPaginationLoading = false;
      notifyListeners();
    }
  }

  Timer? _debounceTimer;

  void onSearchChanged(String keyword, {bool immediate = false}) {
    _debounceTimer?.cancel();

    if (immediate) {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchPetParents(isRefresh: true);
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchPetParents(isRefresh: true);
    });
  }

  void goToPage(int page) {
    if (page < 1 ||
        page > _totalPages ||
        page == _currentPage ||
        _isPaginationLoading ||
        _isLoading) {
      return;
    }
    fetchPetParents(page: page);
  }

  void nextPage() {
    if (_currentPage < _totalPages) {
      goToPage(_currentPage + 1);
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      goToPage(_currentPage - 1);
    }
  }

  Future<bool> updatePetParent({
    required BuildContext context,
    required String id,
    required UpdatePetParentEntity entity,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      final response = await useCases.updatePetParent(id, entity);
      if (response.success) {
        if (response.petParent != null) {
          final index = _petParents.indexWhere((p) => p.id == id);
          if (index != -1) {
            _petParents[index] = response.petParent!;
          } else {
            await fetchPetParents(isRefresh: true);
          }
        } else {
          await fetchPetParents(isRefresh: true);
        }
        if (context.mounted) {
          showToast(
            context,
            response.message.isNotEmpty
                ? response.message
                : 'Pet parent updated successfully',
          );
        }
        return true;
      } else {
        if (context.mounted) {
          showToast(
            context,
            response.message.isNotEmpty
                ? response.message
                : 'Failed to update pet parent',
            isError: true,
          );
        }
        return false;
      }
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
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> deletePetParent({
    required BuildContext context,
    required String id,
  }) async {
    _isDeleting = true;
    notifyListeners();

    try {
      final response = await useCases.deletePetParent(id);
      _petParents.removeWhere((p) => p.id == id);
      if (context.mounted) {
        showToast(
          context,
          response.message.isNotEmpty
              ? response.message
              : 'Pet parent deleted successfully',
        );
      }
      return true;
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
      _isDeleting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
