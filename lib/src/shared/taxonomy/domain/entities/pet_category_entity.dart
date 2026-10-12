class PetCategoryEntity {
  final String id;
  final String title;
  final String? image;
  final String? description;

  const PetCategoryEntity({
    required this.id,
    required this.title,
    this.image,
    this.description,
  });
}
