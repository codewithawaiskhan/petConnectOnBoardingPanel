import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
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

  Future<void> fetchDashboardStats({bool isRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await useCases.getAdminDashboardData();
      _stats = response.stats;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
