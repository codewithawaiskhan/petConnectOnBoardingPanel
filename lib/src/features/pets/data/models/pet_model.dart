import '../../domain/entities/pet_entity.dart';

class PetModel extends PetEntity {
  const PetModel({
    required super.id,
    super.autoIncrementId,
    super.longAutoIncrementId,
    required super.name,
    super.gender,
    super.dob,
    super.breeder,
    super.breed,
    super.registry,
    super.colour,
    super.age,
    super.weight,
    super.weightUnit,
    super.height,
    super.heightUnit,
    super.bloodGroup,
    super.image,
    super.dailyWalkTarget,
    super.description,
    super.gallery = const [],
    super.categoryTitle,
    super.categoryImage,
    super.createdAt,
    super.updatedAt,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    String? categoryTitle;
    String? categoryImage;

    final rawCategory = json['petCategory'];
    if (rawCategory is Map<String, dynamic>) {
      categoryTitle =
          rawCategory['title']?.toString() ?? rawCategory['name']?.toString();
      categoryImage = rawCategory['image']?.toString();
    } else if (rawCategory is String) {
      categoryTitle = rawCategory;
    }

    double? parsedWeight;
    final rawWeight = json['currentWeight'] ?? json['weight'];
    if (rawWeight != null) {
      if (rawWeight is num) {
        parsedWeight = rawWeight.toDouble();
      } else {
        parsedWeight = double.tryParse(rawWeight.toString());
      }
    }

    double? parsedHeight;
    final rawHeight = json['height'];
    if (rawHeight != null) {
      if (rawHeight is num) {
        parsedHeight = rawHeight.toDouble();
      } else {
        parsedHeight = double.tryParse(rawHeight.toString());
      }
    }

    double? parsedWalkTarget;
    final rawWalk = json['dailyWalkTarget'];
    if (rawWalk != null) {
      if (rawWalk is num) {
        parsedWalkTarget = rawWalk.toDouble();
      } else {
        parsedWalkTarget = double.tryParse(rawWalk.toString());
      }
    }

    int? parsedAutoIncrementId;
    if (json['autoIncrementId'] != null) {
      if (json['autoIncrementId'] is num) {
        parsedAutoIncrementId = (json['autoIncrementId'] as num).toInt();
      } else {
        parsedAutoIncrementId = int.tryParse(json['autoIncrementId'].toString());
      }
    }

    int? parsedAge;
    if (json['age'] != null) {
      if (json['age'] is num) {
        parsedAge = (json['age'] as num).toInt();
      } else {
        parsedAge = int.tryParse(json['age'].toString());
      }
    }

    final rawGallery = json['gallery'];
    final List<String> parsedGallery = (rawGallery is List)
        ? rawGallery
            .map((item) => item?.toString() ?? '')
            .where((item) => item.isNotEmpty)
            .toList()
        : const [];

    return PetModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      autoIncrementId: parsedAutoIncrementId,
      longAutoIncrementId: json['longAutoIncrementId']?.toString(),
      name: json['name']?.toString() ?? 'Unnamed Pet',
      gender: json['gender']?.toString(),
      dob: json['dateOfBirth']?.toString() ?? json['dob']?.toString(),
      breeder: json['breeder']?.toString(),
      breed: json['breed']?.toString(),
      registry: json['registry']?.toString(),
      colour: json['colour']?.toString() ?? json['color']?.toString(),
      age: parsedAge,
      weight: parsedWeight,
      weightUnit: json['currentWeightUnit']?.toString() ??
          json['weightUnit']?.toString() ??
          'lb',
      height: parsedHeight,
      heightUnit: json['heightUnit']?.toString() ?? 'cm',
      bloodGroup: json['bloodGroup']?.toString(),
      image: json['image']?.toString() ?? json['featuredImage']?.toString(),
      dailyWalkTarget: parsedWalkTarget,
      description: json['description']?.toString(),
      gallery: parsedGallery,
      categoryTitle: categoryTitle,
      categoryImage: categoryImage,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      if (autoIncrementId != null) 'autoIncrementId': autoIncrementId,
      if (longAutoIncrementId != null) 'longAutoIncrementId': longAutoIncrementId,
      'name': name,
      if (gender != null) 'gender': gender,
      if (dob != null) 'dateOfBirth': dob,
      if (breeder != null) 'breeder': breeder,
      if (breed != null) 'breed': breed,
      if (registry != null) 'registry': registry,
      if (colour != null) 'colour': colour,
      if (age != null) 'age': age,
      if (weight != null) 'currentWeight': weight,
      if (weightUnit != null) 'currentWeightUnit': weightUnit,
      if (height != null) 'height': height,
      if (heightUnit != null) 'heightUnit': heightUnit,
      if (bloodGroup != null) 'bloodGroup': bloodGroup,
      if (image != null) 'image': image,
      if (dailyWalkTarget != null) 'dailyWalkTarget': dailyWalkTarget,
      if (description != null) 'description': description,
      if (gallery.isNotEmpty) 'gallery': gallery,
      if (categoryTitle != null || categoryImage != null)
        'petCategory': {
          if (categoryTitle != null) 'title': categoryTitle,
          if (categoryImage != null) 'image': categoryImage,
        },
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  PetEntity toEntity() {
    return PetEntity(
      id: id,
      autoIncrementId: autoIncrementId,
      longAutoIncrementId: longAutoIncrementId,
      name: name,
      gender: gender,
      dob: dob,
      breeder: breeder,
      breed: breed,
      registry: registry,
      colour: colour,
      age: age,
      weight: weight,
      weightUnit: weightUnit,
      height: height,
      heightUnit: heightUnit,
      bloodGroup: bloodGroup,
      image: image,
      dailyWalkTarget: dailyWalkTarget,
      description: description,
      gallery: gallery,
      categoryTitle: categoryTitle,
      categoryImage: categoryImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory PetModel.fromEntity(PetEntity entity) {
    return PetModel(
      id: entity.id,
      autoIncrementId: entity.autoIncrementId,
      longAutoIncrementId: entity.longAutoIncrementId,
      name: entity.name,
      gender: entity.gender,
      dob: entity.dob,
      breeder: entity.breeder,
      breed: entity.breed,
      registry: entity.registry,
      colour: entity.colour,
      age: entity.age,
      weight: entity.weight,
      weightUnit: entity.weightUnit,
      height: entity.height,
      heightUnit: entity.heightUnit,
      bloodGroup: entity.bloodGroup,
      image: entity.image,
      dailyWalkTarget: entity.dailyWalkTarget,
      description: entity.description,
      gallery: entity.gallery,
      categoryTitle: entity.categoryTitle,
      categoryImage: entity.categoryImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
