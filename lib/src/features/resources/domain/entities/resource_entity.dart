import '../../../resource_categories/domain/entities/resource_category_entity.dart';

class ResourceEntity {
  final String id;
  final String? longAutoIncrementId;
  final String title;
  final String body;
  final ResourceCategoryEntity? postCategory;
  final String? categoryId;
  final String? featuredImage;
  final List<String> gallery;
  final bool isFeatured;
  final int approxReadTimeInMinutes;
  final int helpfulVotesCount;
  final String? postRating;
  final String? createdAt;
  final String? updatedAt;

  const ResourceEntity({
    required this.id,
    this.longAutoIncrementId,
    required this.title,
    required this.body,
    this.postCategory,
    this.categoryId,
    this.featuredImage,
    this.gallery = const [],
    this.isFeatured = false,
    this.approxReadTimeInMinutes = 1,
    this.helpfulVotesCount = 0,
    this.postRating,
    this.createdAt,
    this.updatedAt,
  });
}

class ResourcesResponseEntity {
  final String status;
  final bool success;
  final String message;
  final List<ResourceEntity> resources;
  final int docsCount;
  final int pages;

  const ResourcesResponseEntity({
    required this.status,
    required this.success,
    required this.message,
    required this.resources,
    required this.docsCount,
    required this.pages,
  });
}

class CreateUpdateResourceEntity {
  final String title;
  final String body;
  final String postCategory;
  final bool isFeatured;
  final int approxReadTimeInMinutes;
  final String? featuredImageDataURI;
  final List<String>? galleryDataURIs;

  const CreateUpdateResourceEntity({
    required this.title,
    required this.body,
    required this.postCategory,
    this.isFeatured = false,
    this.approxReadTimeInMinutes = 1,
    this.featuredImageDataURI,
    this.galleryDataURIs,
  });
}
