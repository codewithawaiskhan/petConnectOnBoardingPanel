class SpecialityEntity {
  final String id;
  final String title;
  final String? imageDataURI;
  final String? description;
  final String? status;

  const SpecialityEntity({
    required this.id,
    required this.title,
    this.imageDataURI,
    this.description,
    this.status,
  });
}
