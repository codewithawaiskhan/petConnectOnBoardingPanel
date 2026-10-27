import '../../domain/entities/medical_record_entity.dart';

class MedicalRecordPetModel extends MedicalRecordPetEntity {
  const MedicalRecordPetModel({
    super.id,
    super.name,
    super.image,
  });

  factory MedicalRecordPetModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordPetModel(
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

  MedicalRecordPetEntity toEntity() => MedicalRecordPetEntity(
    id: id,
    name: name,
    image: image,
  );
}

class MedicalRecordModel extends MedicalRecordEntity {
  const MedicalRecordModel({
    required super.id,
    required super.category,
    super.type,
    super.vitalType,
    super.value,
    super.unit,
    super.actionTaken,
    super.notes,
    super.recordedAt,
    super.files = const [],
    super.pet,
    super.createdAt,
    super.updatedAt,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    MedicalRecordPetModel? parsedPet;
    if (json['pet'] is Map<String, dynamic>) {
      parsedPet = MedicalRecordPetModel.fromJson(
        json['pet'] as Map<String, dynamic>,
      );
    } else if (json['pet'] is String) {
      parsedPet = MedicalRecordPetModel(id: json['pet'].toString());
    }

    double? parseValue(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString());
    }

    List<String> parsedFiles = const [];
    if (json['files'] is List) {
      parsedFiles = (json['files'] as List)
          .map((item) {
            if (item is String) return item;
            if (item is Map && item['url'] != null) return item['url'].toString();
            return item?.toString() ?? '';
          })
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return MedicalRecordModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? 'other',
      type: json['type']?.toString(),
      vitalType: json['vitalType']?.toString(),
      value: parseValue(json['value']),
      unit: json['unit']?.toString(),
      actionTaken: json['actionTaken']?.toString(),
      notes: json['notes']?.toString(),
      recordedAt: json['recordedAt']?.toString(),
      files: parsedFiles,
      pet: parsedPet,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'category': category,
    if (type != null) 'type': type,
    if (vitalType != null) 'vitalType': vitalType,
    if (value != null) 'value': value,
    if (unit != null) 'unit': unit,
    if (actionTaken != null) 'actionTaken': actionTaken,
    if (notes != null) 'notes': notes,
    if (recordedAt != null) 'recordedAt': recordedAt,
    'files': files,
    if (pet != null && pet is MedicalRecordPetModel)
      'pet': (pet as MedicalRecordPetModel).toJson(),
    if (createdAt != null) 'createdAt': createdAt,
    if (updatedAt != null) 'updatedAt': updatedAt,
  };

  MedicalRecordEntity toEntity() => MedicalRecordEntity(
    id: id,
    category: category,
    type: type,
    vitalType: vitalType,
    value: value,
    unit: unit,
    actionTaken: actionTaken,
    notes: notes,
    recordedAt: recordedAt,
    files: files,
    pet: pet != null && pet is MedicalRecordPetModel
        ? (pet as MedicalRecordPetModel).toEntity()
        : pet,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
