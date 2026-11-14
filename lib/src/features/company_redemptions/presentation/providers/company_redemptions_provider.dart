import 'package:flutter/material.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/redemption_entity.dart';
import '../../domain/usecases/company_redemptions_usecases.dart';

class CompanyRedemptionsProvider extends ChangeNotifier {
  final GetMyRedemptionsUseCase getMyRedemptionsUseCase;
  final RequestPayPalRedemptionUseCase requestPayPalRedemptionUseCase;

  CompanyRedemptionsProvider({
    required this.getMyRedemptionsUseCase,
    required this.requestPayPalRedemptionUseCase,
  });

  List<RedemptionEntity> _redemptions = [];
  List<RedemptionEntity> get redemptions => _redemptions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

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
    'Paid',
    'Declined',
  ];

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

  Future<void> fetchMyRedemptions({bool isRefresh = false, int? page}) async {
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

      if (_selectedStatus != 'All' && _selectedStatus.trim().isNotEmpty) {
        queryParams['status'] = _selectedStatus.trim();
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

      final response = await getMyRedemptionsUseCase(queryParams);

      _redemptions = response.docs;
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

  Future<bool> requestRedemption(
    double amount,
    String paypalEmail,
    BuildContext context,
  ) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final payload = <String, dynamic>{
        'amount': amount,
        'accountNumber': paypalEmail.trim(),
      };

      await requestPayPalRedemptionUseCase(payload);

      if (context.mounted) {
        showToast(context, 'Withdrawal requested successfully');
      }

      await fetchMyRedemptions(isRefresh: true);
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
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void onStatusChanged(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    _currentPage = 1;
    fetchMyRedemptions(isRefresh: true);
  }

  void applyDateRange({DateTime? from, DateTime? to}) {
    _fromDate = from;
    _toDate = to;
    _currentPage = 1;
    fetchMyRedemptions(isRefresh: true);
  }

  void clearDateRange() {
    if (_fromDate == null && _toDate == null) return;
    _fromDate = null;
    _toDate = null;
    _currentPage = 1;
    fetchMyRedemptions(isRefresh: true);
  }

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchMyRedemptions(isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 ||
        page > _totalPages ||
        page == _currentPage ||
        _isPaginationLoading ||
        _isLoading) {
      return;
    }
    fetchMyRedemptions(page: page);
  }
}

