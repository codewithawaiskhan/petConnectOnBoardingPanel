import 'package:flutter/material.dart';
import '../../domain/entities/resource_entity.dart';
import '../../domain/usecases/resource_usecases.dart';

class ResourceProvider extends ChangeNotifier {
  final ResourceUseCases useCases;

  ResourceProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ResourceEntity? _selectedResource;
  ResourceEntity? get selectedResource => _selectedResource;

  bool _isDetailLoading = false;
  bool get isDetailLoading => _isDetailLoading;

  List<ResourceEntity> _allResources = [];
  int _totalDocs = 0;
  int get totalDocs => _totalDocs;

  int _limit = 10;
  int get limit => _limit;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _selectedCategoryFilter;
  String? get selectedCategoryFilter => _selectedCategoryFilter;

  List<ResourceEntity> get resources => _allResources;

  int get totalCount => _totalDocs;

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchResources(isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 || page > _totalPages || page == _currentPage) return;
    fetchResources(page: page);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 1;
    fetchResources(isRefresh: true);
  }

  void setSelectedCategory(String? categoryId) {
    _selectedCategoryFilter = categoryId;
    _currentPage = 1;
    fetchResources(isRefresh: true);
  }

  Future<void> fetchResources({bool isRefresh = false, int? page}) async {
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
      final response = await useCases.getResources(
        page: targetPage,
        pageSize: _limit,
        postCategory: _selectedCategoryFilter,
        keyword: _searchQuery.trim().isEmpty ? null : _searchQuery.trim(),
      );
      _allResources = response.resources;
      _totalDocs = response.docsCount;
      _totalPages = response.pages > 0 ? response.pages : 1;
      _currentPage = targetPage;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      _isPaginationLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchResourceDetail(
    String id, {
    bool forceRefresh = false,
  }) async {
    final cached = _allResources.where((r) => r.id == id).firstOrNull;
    if (cached != null) {
      _selectedResource = cached;
      notifyListeners();
    }

    if (cached == null || forceRefresh) {
      _isDetailLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final res = await useCases.getResourceDetail(id);
        _selectedResource = res;
      } catch (e) {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      } finally {
        _isDetailLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> addResource(CreateUpdateResourceEntity entity) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await useCases.addResource(entity);
      await fetchResources(isRefresh: true);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateResource(
    String id,
    CreateUpdateResourceEntity entity,
  ) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await useCases.updateResource(id, entity);
      await fetchResources(isRefresh: true);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteResource(String id) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await useCases.deleteResource(id);
      _allResources.removeWhere((r) => r.id == id);
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
