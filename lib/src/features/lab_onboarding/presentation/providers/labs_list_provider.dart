import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/lab_entity.dart';
import '../../domain/entities/update_lab_entity.dart';
import '../../domain/usecases/lab_onboarding_usecases.dart';

class LabsListProvider extends ChangeNotifier {
  final LabOnboardingUseCases useCases;
  Timer? _debounceTimer;

  LabsListProvider({required this.useCases});

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

  List<LabItemEntity> _labs = [];
  List<LabItemEntity> get labs => _labs;

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

  final List<String> statusFilters = ['All', 'Approved', 'Pending', 'Declined'];

  Future<void> fetchLabs({bool isRefresh = false, int? page}) async {
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
      final response = await useCases.getLabs(
        page: targetPage,
        pageSize: _pageSize,
        status: _selectedStatus == 'All' ? null : _selectedStatus,
        keyword: _searchKeyword.trim().isEmpty ? null : _searchKeyword.trim(),
      );

      _labs = response.docs;
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
    fetchLabs(isRefresh: true);
  }

  void onSearchChanged(String keyword, {bool immediate = false}) {
    _debounceTimer?.cancel();
    if (immediate) {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchLabs(isRefresh: true);
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchLabs(isRefresh: true);
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
    fetchLabs(page: page);
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

  Future<bool> updateLab({
    required BuildContext context,
    required String id,
    required UpdateLabEntity entity,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      final response = await useCases.updateLab(id, entity);
      if (response.success) {
        if (response.lab != null) {
          final index = _labs.indexWhere((l) => l.id == id);
          if (index != -1) {
            _labs[index] = response.lab!;
          } else {
            await fetchLabs(isRefresh: true);
          }
        } else {
          await fetchLabs(isRefresh: true);
        }
        if (context.mounted) {
          showToast(
            context,
            response.message.isNotEmpty
                ? response.message
                : 'Diagnostic Lab updated successfully',
          );
        }
        return true;
      } else {
        if (context.mounted) {
          showToast(
            context,
            response.message.isNotEmpty
                ? response.message
                : 'Failed to update lab',
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

  Future<bool> deleteLab({
    required BuildContext context,
    required String id,
  }) async {
    _isDeleting = true;
    notifyListeners();

    try {
      final response = await useCases.deleteLab(id);
      _labs.removeWhere((l) => l.id == id);
      if (_totalDocs > 0) _totalDocs--;
      if (context.mounted) {
        showToast(
          context,
          response.message.isNotEmpty
              ? response.message
              : 'Diagnostic Lab deleted successfully',
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
