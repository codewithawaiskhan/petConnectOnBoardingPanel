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

  final int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String? _selectedCategoryFilter;
  String? get selectedCategoryFilter => _selectedCategoryFilter;

  List<ResourceEntity> get resources {
    var list = _allResources;

    if (_selectedCategoryFilter != null &&
        _selectedCategoryFilter!.trim().isNotEmpty) {
      list = list.where((r) {
        final catId = r.categoryId ?? r.postCategory?.id;
        return catId == _selectedCategoryFilter;
      }).toList();
    }

    if (_searchQuery.trim().isEmpty) {
      return list;
    }

    final q = _searchQuery.trim().toLowerCase();
    return list.where((r) {
      final titleMatch = r.title.toLowerCase().contains(q);
      final bodyMatch = r.body.toLowerCase().contains(q);
      final idMatch = (r.longAutoIncrementId ?? '').toLowerCase().contains(q);
      final catMatch =
          (r.postCategory?.title ?? '').toLowerCase().contains(q);
      return titleMatch || bodyMatch || idMatch || catMatch;
    }).toList();
  }

  int get totalCount => _allResources.length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String? categoryId) {
    _selectedCategoryFilter = categoryId;
    notifyListeners();
  }

  Future<void> fetchResources({bool isRefresh = false}) async {
    if (_isLoading && !isRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await useCases.getResources(
        page: 1,
        pageSize: 50,
      );
      _allResources = response.resources;
      _totalDocs = response.docsCount;
      _totalPages = response.pages;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
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
