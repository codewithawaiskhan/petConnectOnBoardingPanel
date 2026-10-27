import '../../domain/entities/pet_gallery_entity.dart';

class PetGalleryModel extends PetGalleryEntity {
  const PetGalleryModel({
    required super.id,
    required super.imageUrl,
    required super.petName,
    super.remark,
    required super.createdAt,
  });

  factory PetGalleryModel.fromJson(Map<String, dynamic> json) {
    String parsedPetName = "Pet";
    if (json['pet'] is Map<String, dynamic>) {
      final petMap = json['pet'] as Map<String, dynamic>;
      parsedPetName = petMap['name']?.toString() ?? "Pet";
    }

    return PetGalleryModel(
      id: json['_id']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
      petName: parsedPetName,
      remark: json['remark']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'image': imageUrl,
      'pet': {
        'name': petName,
      },
      'remark': remark,
      'createdAt': createdAt,
    };
  }

  PetGalleryEntity toEntity() {
    return PetGalleryEntity(
      id: id,
      imageUrl: imageUrl,
      petName: petName,
      remark: remark,
      createdAt: createdAt,
    );
  }
}
