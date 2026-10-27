class ReminderPetEntity {
  final String? id;
  final String? name;
  final String? image;

  const ReminderPetEntity({
    this.id,
    this.name,
    this.image,
  });
}

class ReminderEntity {
  final String id;
  final String title;
  final String? reminderType;
  final String? routine;
  final String? reminderDateTime;
  final List<String> alerts;
  final String? description;
  final bool isActive;
  final ReminderPetEntity? pet;
  final String? createdAt;
  final String? updatedAt;

  const ReminderEntity({
    required this.id,
    required this.title,
    this.reminderType,
    this.routine,
    this.reminderDateTime,
    this.alerts = const [],
    this.description,
    this.isActive = true,
    this.pet,
    this.createdAt,
    this.updatedAt,
  });

  String get petName => pet?.name ?? "Unknown Pet";
  String? get petImage => pet?.image;
}
