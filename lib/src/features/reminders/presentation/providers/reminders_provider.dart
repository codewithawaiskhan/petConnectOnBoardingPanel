import 'package:flutter/material.dart';
import '../../domain/entities/reminder_entity.dart';
import '../../domain/usecases/reminders_usecases.dart';

class RemindersProvider extends ChangeNotifier {
  final RemindersUseCases useCases;

  RemindersProvider({required this.useCases});

  bool _isRemindersLoading = false;
  bool get isRemindersLoading => _isRemindersLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ReminderEntity> _reminders = const [];
  List<ReminderEntity> get reminders => _reminders;

  String? _currentUserId;
  String? get currentUserId => _currentUserId;

  String _selectedFilter = 'All';
  String get selectedFilter => _selectedFilter;

  List<String> get availableFilters {
    final Set<String> filters = {'All'};
    for (final reminder in _reminders) {
      if (reminder.routine != null && reminder.routine!.isNotEmpty) {
        filters.add(reminder.routine!);
      }
    }
    return filters.toList();
  }

  List<ReminderEntity> get filteredReminders {
    if (_selectedFilter == 'All') return _reminders;
    return _reminders.where((r) {
      return r.routine?.toLowerCase() == _selectedFilter.toLowerCase();
    }).toList();
  }

  void setSelectedFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      notifyListeners();
    }
  }

  Future<void> fetchReminders(
    String userId, {
    bool forceRefresh = false,
  }) async {
    if (userId.isEmpty) return;

    if (!forceRefresh && _currentUserId == userId && _reminders.isNotEmpty) {
      return;
    }

    _currentUserId = userId;
    _isRemindersLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await useCases.getRemindersByUserId(userId);
      _reminders = results;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isRemindersLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _reminders = const [];
    _currentUserId = null;
    _errorMessage = null;
    _selectedFilter = 'All';
    _isRemindersLoading = false;
  }
}
