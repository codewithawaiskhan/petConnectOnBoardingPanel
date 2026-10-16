import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/doctor_list_entity.dart';
import '../../domain/entities/update_doctor_entity.dart';
import '../../domain/usecases/vet_onboarding_usecases.dart';

class VetsListProvider extends ChangeNotifier {
  final VetOnboardingUseCases useCases;
  Timer? _debounceTimer;

  VetsListProvider({required this.useCases});

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
      _currentPage = response.page > 0 ? response.page : targetPage;
      _totalPages = response.pages > 0 ? response.pages : 1;
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

  void onSearchChanged(String keyword, {bool immediate = false}) {
    _debounceTimer?.cancel();
    if (immediate) {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchDoctors(isRefresh: true);
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchDoctors(isRefresh: true);
    });
  }

  void goToPage(int page) {
    if (page < 1 ||
        page > _totalPages ||
        page == _currentPage ||
        _isPaginationLoading ||
        _isLoading) {
      return;
    }
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

  Future<bool> updateDoctor({
    required BuildContext context,
    required String id,
    required UpdateDoctorEntity entity,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      final response = await useCases.updateDoctor(id, entity);
      if (response.success) {
        if (response.doctor != null) {
          final index = _doctors.indexWhere((d) => d.id == id);
          if (index != -1) {
            _doctors[index] = response.doctor!;
          } else {
            await fetchDoctors(isRefresh: true);
          }
        } else {
          await fetchDoctors(isRefresh: true);
        }
        if (context.mounted) {
          showToast(
            context,
            response.message.isNotEmpty
                ? response.message
                : 'Doctor updated successfully',
          );
        }
        return true;
      } else {
        if (context.mounted) {
          showToast(
            context,
            response.message.isNotEmpty
                ? response.message
                : 'Failed to update doctor',
            isError: true,
          );
        }
        return false;
      }
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

  Future<bool> deleteDoctor({
    required BuildContext context,
    required String id,
  }) async {
    _isDeleting = true;
    notifyListeners();

    try {
      final response = await useCases.deleteDoctor(id);
      _doctors.removeWhere((d) => d.id == id);
      if (_totalDocs > 0) _totalDocs--;
      if (context.mounted) {
        showToast(
          context,
          response.message.isNotEmpty
              ? response.message
              : 'Doctor deleted successfully',
        );
      }
      return true;
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

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
