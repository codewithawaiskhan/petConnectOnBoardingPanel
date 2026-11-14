import 'package:flutter/material.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../domain/entities/commission_ledger_entry_entity.dart';
import '../../domain/entities/referral_balance_entity.dart';
import '../../domain/usecases/company_wallet_usecases.dart';

class CompanyWalletProvider extends ChangeNotifier {
  final GetMyReferralBalanceUseCase getMyReferralBalanceUseCase;
  final GetMyCommissionLedgerUseCase getMyCommissionLedgerUseCase;

  CompanyWalletProvider({
    required this.getMyReferralBalanceUseCase,
    required this.getMyCommissionLedgerUseCase,
  });

  // Balance state
  ReferralBalanceEntity? _balance;
  ReferralBalanceEntity? get balance => _balance;

  bool _isLoadingBalance = false;
  bool get isLoadingBalance => _isLoadingBalance;

  String? _balanceError;
  String? get balanceError => _balanceError;

  // Ledger state
  List<CommissionLedgerEntryEntity> _entries = [];
  List<CommissionLedgerEntryEntity> get entries => _entries;

  bool _isLoadingLedger = false;
  bool get isLoadingLedger => _isLoadingLedger;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  String? _ledgerError;
  String? get ledgerError => _ledgerError;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _limit = 10;
  int get limit => _limit;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalDocs = 0;
  int get totalDocs => _totalDocs;

  // Filters
  String _selectedEntryType = 'All'; // 'All', 'credit', 'debit'
  String get selectedEntryType => _selectedEntryType;

  final List<String> entryTypeOptions = const ['All', 'credit', 'debit'];

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

  Future<void> init() async {
    await Future.wait([fetchBalance(), fetchLedgerEntries(isRefresh: true)]);
  }

  Future<void> fetchBalance() async {
    _isLoadingBalance = true;
    _balanceError = null;
    notifyListeners();

    try {
      final result = await getMyReferralBalanceUseCase();
      _balance = result;
      _balanceError = null;
    } on AppException catch (e) {
      _balanceError = e.message;
    } catch (e) {
      _balanceError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingBalance = false;
      notifyListeners();
    }
  }

  Future<void> fetchLedgerEntries({bool isRefresh = false, int? page}) async {
    final targetPage = page ?? (isRefresh ? 1 : _currentPage);

    if (isRefresh || targetPage == 1) {
      _isLoadingLedger = true;
      _ledgerError = null;
      notifyListeners();
    } else {
      _isPaginationLoading = true;
      _ledgerError = null;
      notifyListeners();
    }

    try {
      final queryParams = <String, dynamic>{
        'page': targetPage.toString(),
        'pageSize': _limit.toString(),
        'sortBy': 'createdAt_descending',
      };

      if (_selectedEntryType != 'All' &&
          _selectedEntryType.trim().isNotEmpty) {
        queryParams['entryType'] = _selectedEntryType.trim();
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

      final response = await getMyCommissionLedgerUseCase(queryParams);

      _entries = response.docs;
      _currentPage = targetPage;
      _totalPages = response.pages > 0 ? response.pages : 1;
      _totalDocs = response.docsCount;
      _ledgerError = null;
    } on AppException catch (e) {
      _ledgerError = e.message;
    } catch (e) {
      _ledgerError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingLedger = false;
      _isPaginationLoading = false;
      notifyListeners();
    }
  }

  void onEntryTypeChanged(String type) {
    if (_selectedEntryType == type) return;
    _selectedEntryType = type;
    _currentPage = 1;
    fetchLedgerEntries(isRefresh: true);
  }

  void applyDateRange({DateTime? from, DateTime? to}) {
    _fromDate = from;
    _toDate = to;
    _currentPage = 1;
    fetchLedgerEntries(isRefresh: true);
  }

  void clearDateRange() {
    if (_fromDate == null && _toDate == null) return;
    _fromDate = null;
    _toDate = null;
    _currentPage = 1;
    fetchLedgerEntries(isRefresh: true);
  }

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchLedgerEntries(isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 ||
        page > _totalPages ||
        page == _currentPage ||
        _isPaginationLoading ||
        _isLoadingLedger) {
      return;
    }
    fetchLedgerEntries(page: page);
  }
}

