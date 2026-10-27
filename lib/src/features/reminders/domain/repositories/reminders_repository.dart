import '../entities/reminder_entity.dart';

abstract class RemindersRepository {
  Future<List<ReminderEntity>> getRemindersByUserId(String userId);
}
