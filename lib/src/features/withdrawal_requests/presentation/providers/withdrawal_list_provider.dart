import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/withdrawal_request_entity.dart';
import '../../domain/usecases/withdrawal_usecases.dart';

class WithdrawalListProvider extends ChangeNotifier {
  final GetWithdrawalRequestsUseCase getWithdrawalRequestsUseCase;
  final UpdateWithdrawalStatusUseCase updateWithdrawalStatusUseCase;
  Timer? _debounceTimer;

  WithdrawalListProvider({
    required this.getWithdrawalRequestsUseCase,
    required this.updateWithdrawalStatusUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<WithdrawalRequestEntity> _requests = [];
  List<WithdrawalRequestEntity> get requests => _requests;

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

  String? _fromDate;
  String? get fromDate => _fromDate;

  String? _toDate;
  String? get toDate => _toDate;

  String _selectedStatus = 'All';
  String get selectedStatus => _selectedStatus;

  final List<String> statusFilters = const [
    'All',
    'Submitted',
    'In Review',
    'Approved',
    'Processing',
    'Paid',
    'Failed',
  ];

  bool get hasActiveFilters =>
      _searchKeyword.trim().isNotEmpty ||
      (_fromDate != null && _fromDate!.isNotEmpty) ||
      (_toDate != null && _toDate!.isNotEmpty) ||
      _selectedStatus != 'All';

  Future<void> fetchRequests({bool isRefresh = false, int? page}) async {
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
        'type': 'PayPal',
      };

      if (_searchKeyword.trim().isNotEmpty) {
        queryParams['keyword'] = _searchKeyword.trim();
      }
      if (_fromDate != null && _fromDate!.trim().isNotEmpty) {
        queryParams['from'] = _fromDate!.trim();
      }
      if (_toDate != null && _toDate!.trim().isNotEmpty) {
        queryParams['to'] = _toDate!.trim();
      }
      if (_selectedStatus != 'All' && _selectedStatus.trim().isNotEmpty) {
        queryParams['status'] = _selectedStatus.trim();
      }

      final response = await getWithdrawalRequestsUseCase(queryParams);

      _requests = response.docs;
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

  Future<bool> updateWithdrawalStatus(
    BuildContext context, {
    required String id,
    required String status,
    String? failedReason,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      final trimmedReason = failedReason?.trim();
      final String? effectiveReason =
          (status == 'Failed' &&
                  trimmedReason != null &&
                  trimmedReason.isNotEmpty)
              ? trimmedReason
              : null;

      await updateWithdrawalStatusUseCase(
        id: id,
        status: status,
        failedReason: effectiveReason,
      );

      if (context.mounted) {
        showToast(context, 'Status updated successfully');
      }
      await fetchRequests(page: _currentPage);
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

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchRequests(isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 ||
        page > _totalPages ||
        page == _currentPage ||
        _isPaginationLoading ||
        _isLoading) {
      return;
    }
    fetchRequests(page: page);
  }

  void onStatusChanged(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    _currentPage = 1;
    fetchRequests(isRefresh: true);
  }

  void applyFilters({String? from, String? to}) {
    _fromDate = (from != null && from.trim().isNotEmpty) ? from.trim() : null;
    _toDate = (to != null && to.trim().isNotEmpty) ? to.trim() : null;
    _currentPage = 1;
    fetchRequests(isRefresh: true);
  }

  void clearFilters() {
    _fromDate = null;
    _toDate = null;
    _currentPage = 1;
    fetchRequests(isRefresh: true);
  }

  void onSearchChanged(String keyword, {bool immediate = false}) {
    _debounceTimer?.cancel();
    if (immediate) {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchRequests(isRefresh: true);
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchRequests(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
