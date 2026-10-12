class ServiceEntity {
  final String id;
  final String title;
  final String? specialityObjectId;
  final String? imageDataURI;
  final String? description;
  final String? status;

  const ServiceEntity({
    required this.id,
    required this.title,
    this.specialityObjectId,
    this.imageDataURI,
    this.description,
    this.status,
  });
}
