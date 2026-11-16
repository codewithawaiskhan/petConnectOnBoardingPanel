import 'package:flutter/material.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../domain/entities/company_dashboard_entity.dart';
import '../../domain/usecases/company_dashboard_usecases.dart';

class CompanyDashboardProvider extends ChangeNotifier {
  final GetCompanyDashboardUseCase getCompanyDashboardUseCase;

  CompanyDashboardProvider({
    required this.getCompanyDashboardUseCase,
  });

  CompanyDashboardEntity? _dashboardData;
  CompanyDashboardEntity? get dashboardData => _dashboardData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DateTime? _fromDate;
  DateTime? get fromDate => _fromDate;

  DateTime? _toDate;
  DateTime? get toDate => _toDate;

  bool get hasDateFilter => _fromDate != null || _toDate != null;

  Future<void> fetchDashboardStats({DateTime? from, DateTime? to}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final effectiveFrom = from ?? _fromDate;
      final effectiveTo = to ?? _toDate;

      final data = await getCompanyDashboardUseCase(
        from: effectiveFrom?.toUtc().toIso8601String(),
        to: effectiveTo?.toUtc().toIso8601String(),
      );

      _dashboardData = data;
      _errorMessage = null;
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDashboardData({DateTime? from, DateTime? to}) =>
      fetchDashboardStats(from: from, to: to);

  void updateDateRange(DateTime? from, DateTime? to) {
    if (from != null) {
      _fromDate = DateTime(from.year, from.month, from.day, 0, 0, 0, 0);
    } else {
      _fromDate = null;
    }

    if (to != null) {
      _toDate = DateTime(to.year, to.month, to.day, 23, 59, 59, 999);
    } else {
      _toDate = null;
    }

    fetchDashboardStats(from: _fromDate, to: _toDate);
  }

  void clearDateRange() {
    _fromDate = null;
    _toDate = null;
    fetchDashboardStats();
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
    super.dispose();
  }
}
