import 'package:flutter/material.dart';
import '../../domain/entities/campaign_entity.dart';
import '../../domain/usecases/campaign_usecases.dart';

class CampaignProvider extends ChangeNotifier {
  final CampaignUseCases useCases;

  CampaignProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  bool _isDetailLoading = false;
  bool get isDetailLoading => _isDetailLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CampaignEntity? _selectedCampaign;
  CampaignEntity? get selectedCampaign => _selectedCampaign;

  List<CampaignEntity> _allCampaigns = [];
  List<CampaignEntity> get campaigns => _allCampaigns;

  int _totalDocs = 0;
  int get totalDocs => _totalDocs;
  int get totalCount => _totalDocs;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _limit = 10;
  int get limit => _limit;

  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  String? _fromDate;
  String? get fromDate => _fromDate;

  String? _toDate;
  String? get toDate => _toDate;

  String _sortBy = 'createdAt_descending';
  String get sortBy => _sortBy;

  bool get hasActiveFilters =>
      _searchKeyword.isNotEmpty ||
      (_fromDate != null && _fromDate!.isNotEmpty) ||
      (_toDate != null && _toDate!.isNotEmpty) ||
      _sortBy != 'createdAt_descending';

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchCampaigns(isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 || page > _totalPages || page == _currentPage) return;
    fetchCampaigns(page: page);
  }

  void setSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    _currentPage = 1;
    fetchCampaigns(isRefresh: true);
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    _currentPage = 1;
    fetchCampaigns(isRefresh: true);
  }

  void setDateRange({String? from, String? to}) {
    _fromDate = (from != null && from.trim().isNotEmpty) ? from.trim() : null;
    _toDate = (to != null && to.trim().isNotEmpty) ? to.trim() : null;
    _currentPage = 1;
    fetchCampaigns(isRefresh: true);
  }

  void clearFilters() {
    _searchKeyword = '';
    _fromDate = null;
    _toDate = null;
    _sortBy = 'createdAt_descending';
    _currentPage = 1;
    fetchCampaigns(isRefresh: true);
  }

  Future<void> fetchCampaigns({bool isRefresh = false, int? page}) async {
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
      final response = await useCases.getCampaigns(
        page: targetPage,
        pageSize: _limit,
        from: _fromDate,
        to: _toDate,
        sortBy: _sortBy,
        keyword: _searchKeyword.trim().isEmpty ? null : _searchKeyword.trim(),
      );
      _allCampaigns = response.campaigns;
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

  Future<void> fetchCampaignDetail(
    String id, {
    bool forceRefresh = false,
  }) async {
    final cached = _allCampaigns.where((c) => c.id == id).firstOrNull;
    if (cached != null) {
      _selectedCampaign = cached;
      notifyListeners();
    }

    if (cached == null || forceRefresh) {
      _isDetailLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final campaign = await useCases.getCampaignDetail(id);
        _selectedCampaign = campaign;
      } catch (e) {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      } finally {
        _isDetailLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> addCampaign(CreateUpdateCampaignEntity entity) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await useCases.addCampaign(entity);
      await fetchCampaigns(isRefresh: true);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCampaign(
    String id,
    CreateUpdateCampaignEntity entity,
  ) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await useCases.updateCampaign(id, entity);
      await fetchCampaigns(isRefresh: true);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCampaign(String id) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await useCases.deleteCampaign(id);
      _allCampaigns.removeWhere((c) => c.id == id);
      _totalDocs = (_totalDocs - 1).clamp(0, 999999);
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
