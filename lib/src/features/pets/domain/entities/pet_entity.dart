class PetEntity {
  final String id;
  final int? autoIncrementId;
  final String? longAutoIncrementId;
  final String name;
  final String? gender;
  final String? dob;
  final String? breeder;
  final String? breed;
  final String? registry;
  final String? colour;
  final int? age;
  final double? weight;
  final String? weightUnit;
  final double? height;
  final String? heightUnit;
  final String? bloodGroup;
  final String? image;
  final double? dailyWalkTarget;
  final String? description;
  final List<String> gallery;
  final String? categoryTitle;
  final String? categoryImage;
  final String? createdAt;
  final String? updatedAt;

  const PetEntity({
    required this.id,
    this.autoIncrementId,
    this.longAutoIncrementId,
    required this.name,
    this.gender,
    this.dob,
    this.breeder,
    this.breed,
    this.registry,
    this.colour,
    this.age,
    this.weight,
    this.weightUnit,
    this.height,
    this.heightUnit,
    this.bloodGroup,
    this.image,
    this.dailyWalkTarget,
    this.description,
    this.gallery = const [],
    this.categoryTitle,
    this.categoryImage,
    this.createdAt,
    this.updatedAt,
  });
}
