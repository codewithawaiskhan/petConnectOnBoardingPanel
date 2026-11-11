import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/entities/top_countries_entity.dart';
import '../../domain/usecases/dashboard_usecases.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardUseCases useCases;

  DashboardProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DashboardStatsEntity _stats = const DashboardStatsEntity.empty();
  DashboardStatsEntity get stats => _stats;

  bool _isTopCountriesLoading = false;
  bool get isTopCountriesLoading => _isTopCountriesLoading;

  String? _topCountriesError;
  String? get topCountriesError => _topCountriesError;

  TopCountriesStatsEntity _topCountries = const TopCountriesStatsEntity.empty();
  TopCountriesStatsEntity get topCountries => _topCountries;

  bool _isTopStatesLoading = false;
  bool get isTopStatesLoading => _isTopStatesLoading;

  String? _topStatesError;
  String? get topStatesError => _topStatesError;

  TopCountriesStatsEntity _topStates = const TopCountriesStatsEntity.empty();
  TopCountriesStatsEntity get topStates => _topStates;

  String _selectedStateCountryCode = 'US';
  String get selectedStateCountryCode => _selectedStateCountryCode;

  DateTime? _fromDate;
  DateTime? get fromDate => _fromDate;

  DateTime? _toDate;
  DateTime? get toDate => _toDate;

  bool get hasDateFilter => _fromDate != null || _toDate != null;

  Future<void> fetchDashboardStats({bool isRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await useCases.getAdminDashboardData(
        from: _fromDate?.toIso8601String(),
        to: _toDate?.toIso8601String(),
      );
      _stats = response.stats;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopCountries({bool isRefresh = false}) async {
    _isTopCountriesLoading = true;
    _topCountriesError = null;
    notifyListeners();

    try {
      final response = await useCases.getTopCountries(
        from: _fromDate?.toIso8601String(),
        to: _toDate?.toIso8601String(),
      );
      _topCountries = response.data;
      _topCountriesError = null;
    } catch (e) {
      _topCountriesError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isTopCountriesLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTopStates({
    String? countryCode,
    bool isRefresh = false,
  }) async {
    if (countryCode != null && countryCode.isNotEmpty) {
      _selectedStateCountryCode = countryCode.toUpperCase();
    }
    _isTopStatesLoading = true;
    _topStatesError = null;
    notifyListeners();

    try {
      final response = await useCases.getTopCountries(
        countryCode: _selectedStateCountryCode,
        from: _fromDate?.toIso8601String(),
        to: _toDate?.toIso8601String(),
      );
      _topStates = response.data;
      _topStatesError = null;
    } catch (e) {
      _topStatesError = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isTopStatesLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllDashboardData({bool isRefresh = false}) async {
    await Future.wait([
      fetchDashboardStats(isRefresh: isRefresh),
      fetchTopCountries(isRefresh: isRefresh),
      fetchTopStates(
        countryCode: _selectedStateCountryCode,
        isRefresh: isRefresh,
      ),
    ]);
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

    notifyListeners();
    fetchAllDashboardData(isRefresh: true);
  }

  void clearDateRange() {
    if (_fromDate == null && _toDate == null) return;
    _fromDate = null;
    _toDate = null;
    notifyListeners();
    fetchAllDashboardData(isRefresh: true);
  }
}
