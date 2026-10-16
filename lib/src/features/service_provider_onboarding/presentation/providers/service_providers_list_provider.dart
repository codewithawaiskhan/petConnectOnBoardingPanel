import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/service_provider_list_entity.dart';
import '../../domain/entities/update_service_provider_entity.dart';
import '../../domain/usecases/service_provider_onboarding_usecases.dart';

class ServiceProvidersListProvider extends ChangeNotifier {
  final ServiceProviderOnboardingUseCases useCases;
  Timer? _debounceTimer;

  ServiceProvidersListProvider({required this.useCases});

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

  List<ServiceProviderItemEntity> _serviceProviders = [];
  List<ServiceProviderItemEntity> get serviceProviders => _serviceProviders;

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

  Future<void> fetchServiceProviders({
    bool isRefresh = false,
    int? page,
  }) async {
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
      final response = await useCases.getServiceProviders(
        page: targetPage,
        pageSize: _pageSize,
        status: _selectedStatus == 'All' ? null : _selectedStatus,
        keyword: _searchKeyword.trim().isEmpty ? null : _searchKeyword.trim(),
      );

      _serviceProviders = response.docs;
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
    fetchServiceProviders(isRefresh: true);
  }

  void onSearchChanged(String keyword, {bool immediate = false}) {
    _debounceTimer?.cancel();
    if (immediate) {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchServiceProviders(isRefresh: true);
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchServiceProviders(isRefresh: true);
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
    fetchServiceProviders(page: page);
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

  Future<bool> updateServiceProvider({
    required BuildContext context,
    required String id,
    required UpdateServiceProviderEntity entity,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      final response = await useCases.updateServiceProvider(id, entity);
      if (response.success) {
        if (response.serviceProvider != null) {
          final index = _serviceProviders.indexWhere((sp) => sp.id == id);
          if (index != -1) {
            _serviceProviders[index] = response.serviceProvider!;
          } else {
            await fetchServiceProviders(isRefresh: true);
          }
        } else {
          await fetchServiceProviders(isRefresh: true);
        }
        if (context.mounted) {
          showToast(
            context,
            response.message.isNotEmpty
                ? response.message
                : 'Service Provider updated successfully',
          );
        }
        return true;
      } else {
        if (context.mounted) {
          showToast(
            context,
            response.message.isNotEmpty
                ? response.message
                : 'Failed to update service provider',
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

  Future<bool> deleteServiceProvider({
    required BuildContext context,
    required String id,
  }) async {
    _isDeleting = true;
    notifyListeners();

    try {
      final response = await useCases.deleteServiceProvider(id);
      _serviceProviders.removeWhere((sp) => sp.id == id);
      if (_totalDocs > 0) _totalDocs--;
      if (context.mounted) {
        showToast(
          context,
          response.message.isNotEmpty
              ? response.message
              : 'Service Provider deleted successfully',
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
