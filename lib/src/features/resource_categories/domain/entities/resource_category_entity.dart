class ResourceCategoryEntity {
  final String id;
  final int? autoIncrementId;
  final String? longAutoIncrementId;
  final String title;
  final String? icon;
  final String? featuredImage;
  final bool isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  const ResourceCategoryEntity({
    required this.id,
    required this.title,
    this.autoIncrementId,
    this.longAutoIncrementId,
    this.icon,
    this.featuredImage,
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
    this.v,
  });
}

class ResourceCategoriesResponseEntity {
  final String status;
  final bool success;
  final String message;
  final List<ResourceCategoryEntity> categories;
  final int docsCount;
  final int pages;

  const ResourceCategoriesResponseEntity({
    required this.status,
    required this.success,
    required this.message,
    required this.categories,
    required this.docsCount,
    required this.pages,
  });
}
