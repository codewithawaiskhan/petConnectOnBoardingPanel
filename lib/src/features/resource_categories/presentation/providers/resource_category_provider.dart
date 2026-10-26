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

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _limit = 10;
  int get limit => _limit;

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

  int get totalDocs => categories.length;
  int get totalPages =>
      (totalDocs / _limit).ceil() == 0 ? 1 : (totalDocs / _limit).ceil();

  List<ResourceCategoryEntity> get paginatedCategories {
    final list = categories;
    final startIndex = (_currentPage - 1) * _limit;
    if (startIndex >= list.length) return const [];
    final endIndex = (startIndex + _limit).clamp(0, list.length);
    return list.sublist(startIndex, endIndex);
  }

  int get totalCount => _allCategories.length;

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    notifyListeners();
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages || page == _currentPage) return;
    _currentPage = page;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    notifyListeners();
  }

  Future<void> fetchCategories({bool isRefresh = false}) async {
    if (_isLoading && !isRefresh) return;

    if (isRefresh) {
      _currentPage = 1;
    }
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
