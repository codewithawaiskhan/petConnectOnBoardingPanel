import '../entities/reminder_entity.dart';
import '../repositories/reminders_repository.dart';

class GetRemindersByUserIdUseCase {
  final RemindersRepository repository;

  const GetRemindersByUserIdUseCase({required this.repository});

  Future<List<ReminderEntity>> call(String userId) {
    return repository.getRemindersByUserId(userId);
  }
}

class RemindersUseCases {
  final RemindersRepository repository;

  const RemindersUseCases({required this.repository});

  Future<List<ReminderEntity>> getRemindersByUserId(String userId) {
    return repository.getRemindersByUserId(userId);
  }
}
