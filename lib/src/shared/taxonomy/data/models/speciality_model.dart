import '../../domain/entities/speciality_entity.dart';

class SpecialityModel extends SpecialityEntity {
  const SpecialityModel({
    required super.id,
    required super.title,
    super.imageDataURI,
    super.description,
    super.status,
  });

  factory SpecialityModel.fromJson(Map<String, dynamic> json) {
    return SpecialityModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      imageDataURI:
          json['imageDataURI']?.toString() ?? json['image']?.toString(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      if (imageDataURI != null) 'imageDataURI': imageDataURI,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
    };
  }

  SpecialityEntity toEntity() {
    return SpecialityEntity(
      id: id,
      title: title,
      imageDataURI: imageDataURI,
      description: description,
      status: status,
    );
  }
}
