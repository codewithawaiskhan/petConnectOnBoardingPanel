class PetGalleryEntity {
  final String id;
  final String imageUrl;
  final String petName;
  final String? remark;
  final String createdAt;

  const PetGalleryEntity({
    required this.id,
    required this.imageUrl,
    required this.petName,
    this.remark,
    required this.createdAt,
  });
}
