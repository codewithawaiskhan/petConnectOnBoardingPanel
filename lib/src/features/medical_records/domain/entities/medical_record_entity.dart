class MedicalRecordPetEntity {
  final String? id;
  final String? name;
  final String? image;

  const MedicalRecordPetEntity({
    this.id,
    this.name,
    this.image,
  });
}

class MedicalRecordEntity {
  final String id;
  final String category;
  final String? type;
  final String? vitalType;
  final double? value;
  final String? unit;
  final String? actionTaken;
  final String? notes;
  final String? recordedAt;
  final List<String> files;
  final MedicalRecordPetEntity? pet;
  final String? createdAt;
  final String? updatedAt;

  const MedicalRecordEntity({
    required this.id,
    required this.category,
    this.type,
    this.vitalType,
    this.value,
    this.unit,
    this.actionTaken,
    this.notes,
    this.recordedAt,
    this.files = const [],
    this.pet,
    this.createdAt,
    this.updatedAt,
  });

  String get petName => pet?.name ?? "Unknown Pet";
  String? get petImage => pet?.image;
}
