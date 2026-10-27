import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/reminder_entity.dart';
import '../../domain/repositories/reminders_repository.dart';
import '../data_sources/reminders_remote_data_source.dart';
import '../models/reminder_model.dart';

class RemindersRepositoryImpl implements RemindersRepository {
  final RemindersRemoteDataSource remoteDataSource;

  const RemindersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ReminderEntity>> getRemindersByUserId(String userId) async {
    final Response response =
        await remoteDataSource.getRemindersByUserId(userId);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    List rawDocs = const [];
    final data = rawResponse['data'];

    if (data is Map<String, dynamic>) {
      if (data['docs'] is List) {
        rawDocs = data['docs'] as List;
      } else if (data['reminders'] is List) {
        rawDocs = data['reminders'] as List;
      }
    } else if (data is List) {
      rawDocs = data;
    } else if (rawResponse['docs'] is List) {
      rawDocs = rawResponse['docs'] as List;
    } else if (rawResponse['reminders'] is List) {
      rawDocs = rawResponse['reminders'] as List;
    }

    // STRICT CLEAN ARCHITECTURE TYPE RULE 6:
    // ALWAYS explicitly map as `.map<ReminderEntity>(...)`
    return rawDocs
        .whereType<Map<String, dynamic>>()
        .map<ReminderEntity>((doc) => ReminderModel.fromJson(doc).toEntity())
        .toList();
  }
}
