import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/influencer_entity.dart';
import '../../domain/usecases/my_team_usecases.dart';

class MyTeamProvider extends ChangeNotifier {
  final GetMyInfluencersUseCase getMyInfluencersUseCase;
  final SearchUserByReferralCodeUseCase searchUserByReferralCodeUseCase;
  final CreateAssignInfluencerRequestUseCase
      createAssignInfluencerRequestUseCase;
  Timer? _debounceTimer;

  MyTeamProvider({
    required this.getMyInfluencersUseCase,
    required this.searchUserByReferralCodeUseCase,
    required this.createAssignInfluencerRequestUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  bool _isSearchingUser = false;
  bool get isSearchingUser => _isSearchingUser;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<InfluencerEntity> _influencers = [];
  List<InfluencerEntity> get influencers => _influencers;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _limit = 10;
  int get limit => _limit;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalDocs = 0;
  int get totalDocs => _totalDocs;

  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  String _selectedStatus = 'All';
  String get selectedStatus => _selectedStatus;

  final List<String> statusFilters = const ['All', 'Active', 'Inactive'];

  bool get hasActiveFilters =>
      _searchKeyword.trim().isNotEmpty || _selectedStatus != 'All';

  Future<void> fetchInfluencers({bool isRefresh = false, int? page}) async {
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
      final queryParams = <String, dynamic>{
        'page': targetPage.toString(),
        'pageSize': _limit.toString(),
        'sortBy': 'createdAt_descending',
      };

      if (_searchKeyword.trim().isNotEmpty) {
        queryParams['keyword'] = _searchKeyword.trim();
      }
      if (_selectedStatus != 'All' && _selectedStatus.trim().isNotEmpty) {
        queryParams['status'] = _selectedStatus.trim();
      }

      final response = await getMyInfluencersUseCase(queryParams);

      _influencers = response.docs;
      _currentPage =
          response.currentPage > 0 ? response.currentPage : targetPage;
      _totalPages = response.totalPages > 0 ? response.totalPages : 1;
      _totalDocs = response.docsCount;
      _errorMessage = null;
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      _isPaginationLoading = false;
      notifyListeners();
    }
  }

  Future<ReferredUserLookupEntity?> searchUserByReferralCode(
    String code,
  ) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return null;

    _isSearchingUser = true;
    notifyListeners();

    try {
      return await searchUserByReferralCodeUseCase(trimmed);
    } catch (_) {
      return null;
    } finally {
      _isSearchingUser = false;
      notifyListeners();
    }
  }

  Future<bool> requestInfluencerAssignment(
    String userId,
    BuildContext context,
  ) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      await createAssignInfluencerRequestUseCase({
        'users': [userId],
      });

      if (context.mounted) {
        showToast(context, 'Influencer assignment request sent successfully');
      }
      await fetchInfluencers(isRefresh: true);
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

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchInfluencers(isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 ||
        page > _totalPages ||
        page == _currentPage ||
        _isPaginationLoading ||
        _isLoading) {
      return;
    }
    fetchInfluencers(page: page);
  }

  void onStatusChanged(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    _currentPage = 1;
    fetchInfluencers(isRefresh: true);
  }

  void onSearchChanged(String keyword, {bool immediate = false}) {
    _debounceTimer?.cancel();
    if (immediate) {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchInfluencers(isRefresh: true);
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchKeyword = keyword.trim();
      _currentPage = 1;
      fetchInfluencers(isRefresh: true);
    });
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
    _debounceTimer?.cancel();
    super.dispose();
  }
}

