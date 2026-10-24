import '../../domain/entities/resource_category_entity.dart';

class ResourceCategoryModel extends ResourceCategoryEntity {
  const ResourceCategoryModel({
    required super.id,
    required super.title,
    super.autoIncrementId,
    super.longAutoIncrementId,
    super.icon,
    super.featuredImage,
    super.isDeleted = false,
    super.createdAt,
    super.updatedAt,
    super.v,
  });

  factory ResourceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ResourceCategoryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      autoIncrementId: json['autoIncrementId'] is num
          ? (json['autoIncrementId'] as num).toInt()
          : null,
      longAutoIncrementId: json['longAutoIncrementId']?.toString(),
      icon: json['icon']?.toString() ?? json['iconDataURI']?.toString(),
      featuredImage: json['featuredImage']?.toString(),
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      v: json['__v'] is num ? (json['__v'] as num).toInt() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      if (autoIncrementId != null) 'autoIncrementId': autoIncrementId,
      if (longAutoIncrementId != null) 'longAutoIncrementId': longAutoIncrementId,
      if (icon != null) 'icon': icon,
      if (featuredImage != null) 'featuredImage': featuredImage,
      'isDeleted': isDeleted,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (v != null) '__v': v,
    };
  }

  ResourceCategoryEntity toEntity() {
    return ResourceCategoryEntity(
      id: id,
      title: title,
      autoIncrementId: autoIncrementId,
      longAutoIncrementId: longAutoIncrementId,
      icon: icon,
      featuredImage: featuredImage,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
    );
  }

  factory ResourceCategoryModel.fromEntity(ResourceCategoryEntity entity) {
    return ResourceCategoryModel(
      id: entity.id,
      title: entity.title,
      autoIncrementId: entity.autoIncrementId,
      longAutoIncrementId: entity.longAutoIncrementId,
      icon: entity.icon,
      featuredImage: entity.featuredImage,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      v: entity.v,
    );
  }
}

class ResourceCategoriesResponseModel extends ResourceCategoriesResponseEntity {
  const ResourceCategoriesResponseModel({
    required super.status,
    required super.success,
    required super.message,
    required super.categories,
    required super.docsCount,
    required super.pages,
  });

  factory ResourceCategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString() ?? '';
    final success = json['success'] == true;
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};
    final message =
        data['message']?.toString() ?? json['message']?.toString() ?? '';
    final docs = data['docs'] is List ? data['docs'] as List : const [];

    final categories = docs
        .whereType<Map<String, dynamic>>()
        .map<ResourceCategoryEntity>(
          (item) => ResourceCategoryModel.fromJson(item).toEntity(),
        )
        .toList();

    final docsCount = (data['docsCount'] is num)
        ? (data['docsCount'] as num).toInt()
        : categories.length;
    final pages = (data['pages'] is num) ? (data['pages'] as num).toInt() : 1;

    return ResourceCategoriesResponseModel(
      status: status,
      success: success,
      message: message,
      categories: categories,
      docsCount: docsCount,
      pages: pages,
    );
  }
}
