import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/marketing_company_entity.dart';
import '../../domain/usecases/marketing_company_usecases.dart';

class MarketingCompanyListProvider extends ChangeNotifier {
  final GetMarketingCompaniesUseCase getMarketingCompaniesUseCase;
  final CreateMarketingCompanyUseCase createMarketingCompanyUseCase;
  final UpdateMarketingCompanyUseCase updateMarketingCompanyUseCase;
  final DeleteMarketingCompanyUseCase deleteMarketingCompanyUseCase;
  Timer? _debounceTimer;

  MarketingCompanyListProvider({
    required this.getMarketingCompaniesUseCase,
    required this.createMarketingCompanyUseCase,
    required this.updateMarketingCompanyUseCase,
    required this.deleteMarketingCompanyUseCase,
  });

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

  List<MarketingCompanyEntity> _companies = [];
  List<MarketingCompanyEntity> get companies => _companies;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _limit = 10;
  int get limit => _limit;
  int get pageSize => _limit;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalDocs = 0;
  int get totalDocs => _totalDocs;

  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  String _selectedStatus = 'All';
  String get selectedStatus => _selectedStatus;

  final List<String> statusFilters = const [
    'All',
    'Approved',
    'Pending',
    'In Review',
    'Declined',
    'Blocked',
  ];

  bool get hasActiveFilters =>
      _searchKeyword.trim().isNotEmpty || _selectedStatus != 'All';

  Future<void> fetchCompanies({bool isRefresh = false, int? page}) async {
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
      final queryParams = <String, dynamic>{
        'page': targetPage.toString(),
        'pageSize': _limit.toString(),
        'sortBy': 'createdAt_descending',
      };

      if (_searchKeyword.trim().isNotEmpty) {
        queryParams['keyword'] = _searchKeyword.trim();
      }
      if (_selectedStatus != 'All' && _selectedStatus.trim().isNotEmpty) {
        queryParams['status'] = _selectedStatus.trim();
      }

      final response = await getMarketingCompaniesUseCase(queryParams);

      _companies = response.docs;
      _currentPage =
          response.currentPage > 0 ? response.currentPage : targetPage;
      _totalPages = response.totalPages > 0 ? response.totalPages : 1;
      _totalDocs = response.docsCount;
      _errorMessage = null;
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      _isPaginationLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCompany(
    Map<String, dynamic> payload,
    BuildContext context,
  ) async {
    _isUpdating = true;
    notifyListeners();

    try {
      await createMarketingCompanyUseCase(payload);

      if (context.mounted) {
        showToast(context, 'Marketing company created successfully');
      }
      await fetchCompanies(isRefresh: true);
      return true;
    } on AppException catch (e) {
      if (context.mounted) {
        showToast(context, e.message, isError: true);
      }
      return false;
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

  Future<bool> updateCompany(
    String id,
    Map<String, dynamic> payload,
    BuildContext context,
  ) async {
    _isUpdating = true;
    notifyListeners();

    try {
      await updateMarketingCompanyUseCase(id, payload);

      if (context.mounted) {
        showToast(context, 'Marketing company updated successfully');
      }
      await fetchCompanies(page: _currentPage);
      return true;
    } on AppException catch (e) {
      if (context.mounted) {
        showToast(context, e.message, isError: true);
      }
      return false;
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

  Future<bool> deleteCompany(String id, BuildContext context) async {
    _isDeleting = true;
    notifyListeners();

    try {
      await deleteMarketingCompanyUseCase(id);
      _companies.removeWhere((c) => c.id == id);
      if (_totalDocs > 0) _totalDocs--;

      if (context.mounted) {
        showToast(context, 'Marketing company deleted successfully');
      }
      return true;
    } on AppException catch (e) {
      if (context.mounted) {
        showToast(context, e.message, isError: true);
      }
      return false;
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

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchCompanies(isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 ||
        page > _totalPages ||
        page == _currentPage ||
        _isPaginationLoading ||
        _isLoading) {
      return;
    }
    fetchCompanies(page: page);
  }

  void onStatusChanged(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    _currentPage = 1;
    fetchCompanies(isRefresh: true);
  }

  void onSearchChanged(String keyword, {bool immediate = false}) {
    _debounceTimer?.cancel();
    if (immediate) {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchCompanies(isRefresh: true);
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchCompanies(isRefresh: true);
    });
  }

  bool _isDisposed = false;

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    super.dispose();
  }
}

