import '../../domain/entities/pet_category_entity.dart';

class PetCategoryModel extends PetCategoryEntity {
  const PetCategoryModel({
    required super.id,
    required super.title,
    super.image,
    super.description,
  });

  factory PetCategoryModel.fromJson(Map<String, dynamic> json) {
    return PetCategoryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? json['imageDataURI']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      if (image != null) 'image': image,
      if (description != null) 'description': description,
    };
  }

  PetCategoryEntity toEntity() {
    return PetCategoryEntity(
      id: id,
      title: title,
      image: image,
      description: description,
    );
  }
}
