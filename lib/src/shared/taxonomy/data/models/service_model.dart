import '../../domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.title,
    super.specialityObjectId,
    super.imageDataURI,
    super.description,
    super.status,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      specialityObjectId:
          json['specialityObjectId']?.toString() ??
          json['speciality']?.toString(),
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
      if (specialityObjectId != null) 'specialityObjectId': specialityObjectId,
      if (imageDataURI != null) 'imageDataURI': imageDataURI,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
    };
  }

  ServiceEntity toEntity() {
    return ServiceEntity(
      id: id,
      title: title,
      specialityObjectId: specialityObjectId,
      imageDataURI: imageDataURI,
      description: description,
      status: status,
    );
  }
}
