import 'package:flutter/material.dart';
import '../../domain/entities/doctor_list_entity.dart';
import '../../domain/usecases/vet_onboarding_usecases.dart';

class VetsListProvider extends ChangeNotifier {
  final VetOnboardingUseCases useCases;

  VetsListProvider({required this.useCases});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<DoctorItemEntity> _doctors = [];
  List<DoctorItemEntity> get doctors => _doctors;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalDocs = 0;
  int get totalDocs => _totalDocs;

  final int _pageSize = 10;
  int get pageSize => _pageSize;

  String _selectedStatus = 'All';
  String get selectedStatus => _selectedStatus;

  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  final List<String> statusFilters = [
    'All',
    'Approved',
    'Pending',
    'In Review',
    'Declined',
    'Blocked',
  ];

  Future<void> fetchDoctors({bool isRefresh = false, int? page}) async {
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
      final response = await useCases.getDoctors(
        page: targetPage,
        pageSize: _pageSize,
        status: _selectedStatus == 'All' ? null : _selectedStatus,
        keyword: _searchKeyword.trim().isEmpty ? null : _searchKeyword.trim(),
      );

      _doctors = response.docs;
      _currentPage = response.page;
      _totalPages = response.pages;
      _totalDocs = response.docsCount;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      _isPaginationLoading = false;
      notifyListeners();
    }
  }

  void onStatusChanged(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    _currentPage = 1;
    fetchDoctors(isRefresh: true);
  }

  void onSearchChanged(String keyword) {
    _searchKeyword = keyword;
    _currentPage = 1;
    fetchDoctors(isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 || page > _totalPages || page == _currentPage) return;
    fetchDoctors(page: page);
  }

  void nextPage() {
    if (_currentPage < _totalPages) {
      goToPage(_currentPage + 1);
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      goToPage(_currentPage - 1);
    }
  }
}
