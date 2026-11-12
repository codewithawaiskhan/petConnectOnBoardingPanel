import 'package:flutter/material.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../domain/entities/company_dashboard_entity.dart';
import '../../domain/usecases/company_dashboard_usecases.dart';

class CompanyDashboardProvider extends ChangeNotifier {
  final GetMyCompanyProfileUseCase getMyCompanyProfileUseCase;
  final GetMyReferralStatsUseCase getMyReferralStatsUseCase;

  CompanyDashboardProvider({
    required this.getMyCompanyProfileUseCase,
    required this.getMyReferralStatsUseCase,
  });

  CompanyProfileEntity _profile = const CompanyProfileEntity.empty();
  CompanyProfileEntity get profile => _profile;

  ReferralStatsEntity _stats = const ReferralStatsEntity.empty();
  ReferralStatsEntity get stats => _stats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DateTime? _fromDate;
  DateTime? get fromDate => _fromDate;

  DateTime? _toDate;
  DateTime? get toDate => _toDate;

  bool get hasDateFilter => _fromDate != null || _toDate != null;

  Future<void> fetchDashboardData({DateTime? from, DateTime? to}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        getMyCompanyProfileUseCase(),
        getMyReferralStatsUseCase(
          from: (from ?? _fromDate)?.toUtc().toIso8601String(),
          to: (to ?? _toDate)?.toUtc().toIso8601String(),
        ),
      ]);

      _profile = results[0] as CompanyProfileEntity;
      _stats = results[1] as ReferralStatsEntity;
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

    fetchDashboardData(from: _fromDate, to: _toDate);
  }

  void clearDateRange() {
    if (_fromDate == null && _toDate == null) return;
    _fromDate = null;
    _toDate = null;
    fetchDashboardData();
  }
}

