import 'package:flutter/material.dart';
import '../../../../core/error/app_exceptions.dart';
import '../../../../core/utils/show_toast.dart';
import '../../domain/entities/assignment_request_entity.dart';
import '../../domain/usecases/assignment_requests_usecases.dart';

class AssignmentRequestsProvider extends ChangeNotifier {
  final GetAssignmentRequestsUseCase getAssignmentRequestsUseCase;
  final UpdateAssignmentRequestStatusUseCase updateAssignmentRequestStatusUseCase;

  AssignmentRequestsProvider({
    required this.getAssignmentRequestsUseCase,
    required this.updateAssignmentRequestStatusUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  final Set<String> _updatingIds = {};
  bool isUpdating(String id) => _updatingIds.contains(id);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<AssignmentRequestEntity> _requests = [];
  List<AssignmentRequestEntity> get requests => _requests;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _limit = 10;
  int get limit => _limit;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  int _totalDocs = 0;
  int get totalDocs => _totalDocs;

  String _selectedStatus = 'All';
  String get selectedStatus => _selectedStatus;

  final List<String> statusFilters = const [
    'All',
    'Submitted',
    'Approved',
    'Declined',
  ];

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

  Future<void> fetchRequests({bool isRefresh = false, int? page}) async {
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

      if (_selectedStatus != 'All' && _selectedStatus.trim().isNotEmpty) {
        queryParams['status'] = _selectedStatus.trim();
      }

      final response = await getAssignmentRequestsUseCase(queryParams);

      _requests = response.docs;
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

  Future<bool> updateRequestStatus(
    String requestId,
    String newStatus,
    BuildContext context,
  ) async {
    _updatingIds.add(requestId);
    notifyListeners();

    try {
      await updateAssignmentRequestStatusUseCase(
        id: requestId,
        status: newStatus,
      );

      final idx = _requests.indexWhere((r) => r.id == requestId);
      if (idx != -1) {
        _requests[idx] = _requests[idx].copyWith(status: newStatus);
      }

      if (context.mounted) {
        showToast(context, 'Request $newStatus successfully');
      }
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
      _updatingIds.remove(requestId);
      notifyListeners();
    }
  }

  void onStatusChanged(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    _currentPage = 1;
    fetchRequests(isRefresh: true);
  }

  void setLimit(int newLimit) {
    if (_limit == newLimit) return;
    _limit = newLimit;
    _currentPage = 1;
    fetchRequests(isRefresh: true);
  }

  void goToPage(int page) {
    if (page < 1 ||
        page > _totalPages ||
        page == _currentPage ||
        _isPaginationLoading ||
        _isLoading) {
      return;
    }
    fetchRequests(page: page);
  }
}
