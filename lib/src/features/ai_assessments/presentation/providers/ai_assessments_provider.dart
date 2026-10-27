import 'package:flutter/material.dart';
import '../../domain/entities/ai_assessment_entity.dart';
import '../../domain/usecases/ai_assessments_usecases.dart';

class AiAssessmentsProvider extends ChangeNotifier {
  final AiAssessmentsUseCases useCases;

  AiAssessmentsProvider({required this.useCases});

  bool _isAssessmentsLoading = false;
  bool get isAssessmentsLoading => _isAssessmentsLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<AiAssessmentEntity> _assessments = const [];
  List<AiAssessmentEntity> get assessments => _assessments;

  String? _currentUserId;
  String? get currentUserId => _currentUserId;

  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  List<String> get availableFilters {
    final Set<String> filters = {'All'};
    for (final a in _assessments) {
      if (a.triageLevel.isNotEmpty) {
        filters.add(a.triageLevel);
      }
      if (a.type.isNotEmpty) {
        filters.add(a.type);
      }
    }
    return filters.toList();
  }

  List<AiAssessmentEntity> get filteredAssessments {
    if (_selectedFilter == 'All') return _assessments;
    return _assessments.where((a) {
      final matchesTriage =
          a.triageLevel.toLowerCase() == _selectedFilter.toLowerCase();
      final matchesType = a.type.toLowerCase() == _selectedFilter.toLowerCase();
      return matchesTriage || matchesType;
    }).toList();
  }

  void setSelectedFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      notifyListeners();
    }
  }

  Future<void> fetchAiAssessments(
    String userId, {
    bool forceRefresh = false,
  }) async {
    if (userId.isEmpty) return;

    if (!forceRefresh && _currentUserId == userId && _assessments.isNotEmpty) {
      return;
    }

    _currentUserId = userId;
    _isAssessmentsLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await useCases.getAiAssessmentsByUserId(userId);
      _assessments = results;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isAssessmentsLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _assessments = const [];
    _currentUserId = null;
    _errorMessage = null;
    _selectedFilter = 'All';
    _isAssessmentsLoading = false;
  }
}
