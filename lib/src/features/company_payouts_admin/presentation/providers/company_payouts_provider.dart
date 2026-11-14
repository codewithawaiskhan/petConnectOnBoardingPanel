import 'package:flutter/material.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../../company_redemptions/domain/entities/redemption_entity.dart';
import '../../domain/usecases/company_payouts_usecases.dart';

class CompanyPayoutsProvider extends ChangeNotifier {
  final CompanyPayoutsUseCases useCases;

  CompanyPayoutsProvider({
    required this.useCases,
  });

  List<RedemptionEntity> _payouts = [];
  List<RedemptionEntity> get payouts => _payouts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  final Set<String> _updatingIds = {};
  bool isUpdating(String id) => _updatingIds.contains(id);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _limit = 10;
  int get limit => _limit;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalDocs = 0;
  int get totalDocs => _totalDocs;

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

  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  DateTime? _fromDate;
  DateTime? get fromDate => _fromDate;

  DateTime? _toDate;
  DateTime? get toDate => _toDate;

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
    super.dispose();
  }

  Future<void> fetchPayouts({bool isRefresh = false, int? page}) async {
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
        'type': 'PayPal',
        'isMarketingCompany': 'true',
      };

      if (_selectedStatus != 'All' && _selectedStatus.trim().isNotEmpty) {
        queryParams['status'] = _selectedStatus.trim();
      }

      if (_searchKeyword.trim().isNotEmpty) {
        queryParams['keyword'] = _searchKeyword.trim();
      }

      if (_fromDate != null) {
        final start = DateTime(
          _fromDate!.year,
          _fromDate!.month,
          _fromDate!.day,
          0,
          0,
          0,
        );
        queryParams['from'] = start.toUtc().toIso8601String();
      }

      if (_toDate != null) {
        final end = DateTime(
          _toDate!.year,
          _toDate!.month,
          _toDate!.day,
          23,
          59,
          59,
          999,
        );
        queryParams['to'] = end.toUtc().toIso8601String();
      }

      final response = await useCases.getAllPayouts(queryParams);

      _payouts = response.docs;
      _currentPage = targetPage;
      _totalPages = response.pages > 0 ? response.pages : 1;
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

  Future<bool> updateStatus(
    String id,
    String newStatus, {
    String? failedReason,
    required BuildContext context,
  }) async {
    _updatingIds.add(id);
    notifyListeners();

    try {
      await useCases.updatePayoutStatus(
        id: id,
        status: newStatus,
        failedReason: failedReason,
      );

      if (context.mounted) {
        showToast(context, 'Payout updated to $newStatus successfully');
      }

      await fetchPayouts(isRefresh: true);
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
      _updatingIds.remove(id);
      notifyListeners();
    }
  }

  void onStatusChanged(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    _currentPage = 1;
    fetchPayouts(isRefresh: true);
  }

  void onSearchChanged(String query) {
    _searchKeyword = query;
    _currentPage = 1;
    fetchPayouts(isRefresh: true);
  }

  void applyDateRange({DateTime? from, DateTime? to}) {
    _fromDate = from;
    _toDate = to;
    _currentPage = 1;
    fetchPayouts(isRefresh: true);
  }

  void clearFilters() {
    _selectedStatus = 'All';
    _searchKeyword = '';
    _fromDate = null;
    _toDate = null;
    _currentPage = 1;
    fetchPayouts(isRefresh: true);
  }

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchPayouts(isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 ||
        page > _totalPages ||
        page == _currentPage ||
        _isPaginationLoading ||
        _isLoading) {
      return;
    }
    fetchPayouts(page: page);
  }
}

