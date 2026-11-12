import 'package:flutter/material.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/commission_settings_entity.dart';
import '../../domain/usecases/commission_settings_usecases.dart';

class CommissionSettingsProvider extends ChangeNotifier {
  final GetCompanyCommissionPoliciesUseCase getCompanyCommissionPoliciesUseCase;
  final CreateCompanyCommissionPolicyUseCase
      createCompanyCommissionPolicyUseCase;
  final GetRenewalCommissionSettingsUseCase getRenewalCommissionSettingsUseCase;
  final CreateRenewalCommissionSettingsUseCase
      createRenewalCommissionSettingsUseCase;

  CommissionSettingsProvider({
    required this.getCompanyCommissionPoliciesUseCase,
    required this.createCompanyCommissionPolicyUseCase,
    required this.getRenewalCommissionSettingsUseCase,
    required this.createRenewalCommissionSettingsUseCase,
  });

  // Global Settings State
  RenewalCommissionSettingsEntity? _globalSettings;
  RenewalCommissionSettingsEntity? get globalSettings => _globalSettings;

  List<RenewalCommissionSettingsEntity> _globalSettingsHistory = [];
  List<RenewalCommissionSettingsEntity> get globalSettingsHistory =>
      _globalSettingsHistory;

  bool _isLoadingGlobalSettings = false;
  bool get isLoadingGlobalSettings => _isLoadingGlobalSettings;

  String? _globalErrorMessage;
  String? get globalErrorMessage => _globalErrorMessage;

  // Company Policies State
  List<CompanyCommissionPolicyEntity> _companyPolicies = [];
  List<CompanyCommissionPolicyEntity> get companyPolicies => _companyPolicies;

  bool _isLoadingCompanyPolicies = false;
  bool get isLoadingCompanyPolicies => _isLoadingCompanyPolicies;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  String? _policiesErrorMessage;
  String? get policiesErrorMessage => _policiesErrorMessage;

  String? _selectedCompanyId;
  String? get selectedCompanyId => _selectedCompanyId;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _limit = 10;
  int get limit => _limit;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalDocs = 0;
  int get totalDocs => _totalDocs;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

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

  Future<void> fetchGlobalSettings() async {
    _isLoadingGlobalSettings = true;
    _globalErrorMessage = null;
    notifyListeners();

    try {
      final response = await getRenewalCommissionSettingsUseCase({
        'page': '1',
        'pageSize': '10',
        'sortBy': 'createdAt_descending',
      });

      _globalSettingsHistory = response.docs;
      _globalSettings = response.docs.isNotEmpty ? response.docs.first : null;
      _globalErrorMessage = null;
    } on AppException catch (e) {
      _globalErrorMessage = e.message;
    } catch (e) {
      _globalErrorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingGlobalSettings = false;
      notifyListeners();
    }
  }

  Future<bool> createGlobalSettings(
    Map<String, dynamic> payload,
    BuildContext context,
  ) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await createRenewalCommissionSettingsUseCase(payload);

      if (context.mounted) {
        showToast(context, 'Global commission settings created successfully');
      }
      await fetchGlobalSettings();
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

  Future<void> fetchCompanyPolicies({
    String? companyId,
    int? page,
    bool isRefresh = false,
  }) async {
    final targetPage = page ?? (isRefresh ? 1 : _currentPage);

    if (isRefresh || targetPage == 1) {
      _isLoadingCompanyPolicies = true;
      _policiesErrorMessage = null;
      notifyListeners();
    } else {
      _isPaginationLoading = true;
      _policiesErrorMessage = null;
      notifyListeners();
    }

    try {
      final queryParams = <String, dynamic>{
        'page': targetPage.toString(),
        'pageSize': _limit.toString(),
        'sortBy': 'createdAt_descending',
      };

      final effectiveCompanyId = companyId ?? _selectedCompanyId;
      if (effectiveCompanyId != null && effectiveCompanyId.trim().isNotEmpty) {
        queryParams['company'] = effectiveCompanyId.trim();
      }

      final response = await getCompanyCommissionPoliciesUseCase(queryParams);

      _companyPolicies = response.docs;
      _currentPage =
          response.currentPage > 0 ? response.currentPage : targetPage;
      _totalPages = response.totalPages > 0 ? response.totalPages : 1;
      _totalDocs = response.docsCount;
      _policiesErrorMessage = null;
    } on AppException catch (e) {
      _policiesErrorMessage = e.message;
    } catch (e) {
      _policiesErrorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoadingCompanyPolicies = false;
      _isPaginationLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCompany(String? companyId) {
    final normalized =
        (companyId != null && companyId.trim().isNotEmpty) ? companyId : null;
    if (_selectedCompanyId == normalized) return;
    _selectedCompanyId = normalized;
    _currentPage = 1;
    fetchCompanyPolicies(companyId: _selectedCompanyId, isRefresh: true);
  }

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchCompanyPolicies(companyId: _selectedCompanyId, isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 ||
        page > _totalPages ||
        page == _currentPage ||
        _isPaginationLoading ||
        _isLoadingCompanyPolicies) {
      return;
    }
    fetchCompanyPolicies(companyId: _selectedCompanyId, page: page);
  }

  Future<bool> createCompanyPolicy(
    Map<String, dynamic> payload,
    BuildContext context,
  ) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await createCompanyCommissionPolicyUseCase(payload);

      if (context.mounted) {
        showToast(context, 'Company commission policy assigned successfully');
      }
      await fetchCompanyPolicies(
        companyId: _selectedCompanyId,
        isRefresh: true,
      );
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
}

