import 'package:flutter/material.dart';
import '../../domain/entities/resource_category_entity.dart';
import '../../domain/usecases/resource_category_usecases.dart';

class ResourceCategoryProvider extends ChangeNotifier {
  final ResourceCategoryUseCases useCases;

  ResourceCategoryProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ResourceCategoryEntity> _allCategories = [];
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<ResourceCategoryEntity> get categories {
    if (_searchQuery.trim().isEmpty) {
      return _allCategories;
    }
    final q = _searchQuery.trim().toLowerCase();
    return _allCategories.where((c) {
      final titleMatch = c.title.toLowerCase().contains(q);
      final idMatch = (c.longAutoIncrementId ?? '').toLowerCase().contains(q) ||
          c.id.toLowerCase().contains(q);
      return titleMatch || idMatch;
    }).toList();
  }

  int get totalCount => _allCategories.length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchCategories({bool isRefresh = false}) async {
    if (_isLoading && !isRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await useCases.getCategories();
      _allCategories = response.categories;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCategory({
    required String title,
    String? iconDataURI,
  }) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await useCases.addCategory(
        title: title,
        iconDataURI: iconDataURI,
      );
      await fetchCategories(isRefresh: true);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCategory({
    required String id,
    required String title,
    String? iconDataURI,
  }) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await useCases.updateCategory(
        id: id,
        title: title,
        iconDataURI: iconDataURI,
      );
      await fetchCategories(isRefresh: true);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCategory(String id) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await useCases.deleteCategory(id);
      _allCategories.removeWhere((c) => c.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }
}
