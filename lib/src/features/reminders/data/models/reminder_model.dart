import '../../domain/entities/reminder_entity.dart';

class ReminderPetModel extends ReminderPetEntity {
  const ReminderPetModel({
    super.id,
    super.name,
    super.image,
  });

  factory ReminderPetModel.fromJson(Map<String, dynamic> json) {
    return ReminderPetModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name']?.toString(),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    if (name != null) 'name': name,
    if (image != null) 'image': image,
  };

  ReminderPetEntity toEntity() => ReminderPetEntity(
    id: id,
    name: name,
    image: image,
  );
}

class ReminderModel extends ReminderEntity {
  const ReminderModel({
    required super.id,
    required super.title,
    super.reminderType,
    super.routine,
    super.reminderDateTime,
    super.alerts = const [],
    super.description,
    super.isActive = true,
    super.pet,
    super.createdAt,
    super.updatedAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    ReminderPetModel? parsedPet;
    if (json['pet'] is Map<String, dynamic>) {
      parsedPet = ReminderPetModel.fromJson(
        json['pet'] as Map<String, dynamic>,
      );
    } else if (json['pet'] is String) {
      parsedPet = ReminderPetModel(id: json['pet'].toString());
    }

    List<String> parsedAlerts = const [];
    if (json['alerts'] is List) {
      parsedAlerts = (json['alerts'] as List)
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    bool parseIsActive(dynamic val) {
      if (val == null) return true;
      if (val is bool) return val;
      if (val is num) return val != 0;
      return val.toString().toLowerCase() == 'true';
    }

    return ReminderModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled Reminder',
      reminderType: json['reminderType']?.toString() ?? 'general',
      routine: json['routine']?.toString() ?? 'one_time',
      reminderDateTime: json['reminderDateTime']?.toString(),
      alerts: parsedAlerts,
      description: json['description']?.toString(),
      isActive: parseIsActive(json['isActive']),
      pet: parsedPet,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    if (reminderType != null) 'reminderType': reminderType,
    if (routine != null) 'routine': routine,
    if (reminderDateTime != null) 'reminderDateTime': reminderDateTime,
    'alerts': alerts,
    if (description != null) 'description': description,
    'isActive': isActive,
    if (pet != null && pet is ReminderPetModel)
      'pet': (pet as ReminderPetModel).toJson(),
    if (createdAt != null) 'createdAt': createdAt,
    if (updatedAt != null) 'updatedAt': updatedAt,
  };

  ReminderEntity toEntity() => ReminderEntity(
    id: id,
    title: title,
    reminderType: reminderType,
    routine: routine,
    reminderDateTime: reminderDateTime,
    alerts: alerts,
    description: description,
    isActive: isActive,
    pet: pet != null && pet is ReminderPetModel
        ? (pet as ReminderPetModel).toEntity()
        : pet,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
