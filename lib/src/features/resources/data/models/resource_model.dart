import '../../../resource_categories/data/models/resource_category_model.dart';
import '../../domain/entities/resource_entity.dart';

class ResourceModel extends ResourceEntity {
  const ResourceModel({
    required super.id,
    super.longAutoIncrementId,
    required super.title,
    required super.body,
    super.postCategory,
    super.categoryId,
    super.featuredImage,
    super.gallery = const [],
    super.isFeatured = false,
    super.approxReadTimeInMinutes = 1,
    super.helpfulVotesCount = 0,
    super.postRating,
    super.createdAt,
    super.updatedAt,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    String? catId;
    ResourceCategoryModel? catModel;

    final rawCat = json['postCategory'];
    if (rawCat is Map<String, dynamic>) {
      catModel = ResourceCategoryModel.fromJson(rawCat);
      catId = catModel.id;
    } else if (rawCat is String) {
      catId = rawCat;
    }

    final rawGallery = json['gallery'];
    final List<String> galleryList = (rawGallery is List)
        ? rawGallery.map((e) => e.toString()).toList()
        : const [];

    return ResourceModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      longAutoIncrementId: json['longAutoIncrementId']?.toString(),
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      postCategory: catModel?.toEntity(),
      categoryId: catId,
      featuredImage: json['featuredImage']?.toString() ??
          json['featuredImageDataURI']?.toString(),
      gallery: galleryList,
      isFeatured: json['isFeatured'] == true,
      approxReadTimeInMinutes: (json['approxReadTimeInMinutes'] is num)
          ? (json['approxReadTimeInMinutes'] as num).toInt()
          : 1,
      helpfulVotesCount: (json['helpfulVotesCount'] is num)
          ? (json['helpfulVotesCount'] as num).toInt()
          : 0,
      postRating: json['postRating']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      if (longAutoIncrementId != null)
        'longAutoIncrementId': longAutoIncrementId,
      'title': title,
      'body': body,
      'postCategory': categoryId ?? postCategory?.id,
      if (featuredImage != null) 'featuredImage': featuredImage,
      'gallery': gallery,
      'isFeatured': isFeatured,
      'approxReadTimeInMinutes': approxReadTimeInMinutes,
      'helpfulVotesCount': helpfulVotesCount,
      if (postRating != null) 'postRating': postRating,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  ResourceEntity toEntity() {
    return ResourceEntity(
      id: id,
      longAutoIncrementId: longAutoIncrementId,
      title: title,
      body: body,
      postCategory: postCategory,
      categoryId: categoryId,
      featuredImage: featuredImage,
      gallery: gallery,
      isFeatured: isFeatured,
      approxReadTimeInMinutes: approxReadTimeInMinutes,
      helpfulVotesCount: helpfulVotesCount,
      postRating: postRating,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ResourceModel.fromEntity(ResourceEntity entity) {
    return ResourceModel(
      id: entity.id,
      longAutoIncrementId: entity.longAutoIncrementId,
      title: entity.title,
      body: entity.body,
      postCategory: entity.postCategory,
      categoryId: entity.categoryId,
      featuredImage: entity.featuredImage,
      gallery: entity.gallery,
      isFeatured: entity.isFeatured,
      approxReadTimeInMinutes: entity.approxReadTimeInMinutes,
      helpfulVotesCount: entity.helpfulVotesCount,
      postRating: entity.postRating,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

class ResourcesResponseModel extends ResourcesResponseEntity {
  const ResourcesResponseModel({
    required super.status,
    required super.success,
    required super.message,
    required super.resources,
    required super.docsCount,
    required super.pages,
  });

  factory ResourcesResponseModel.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString() ?? '';
    final success = json['success'] == true;
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};
    final message =
        data['message']?.toString() ?? json['message']?.toString() ?? '';
    final docs = data['docs'] is List ? data['docs'] as List : const [];

    final resources = docs
        .whereType<Map<String, dynamic>>()
        .map<ResourceEntity>((item) => ResourceModel.fromJson(item).toEntity())
        .toList();

    final docsCount = (data['docsCount'] is num)
        ? (data['docsCount'] as num).toInt()
        : resources.length;
    final pages = (data['pages'] is num) ? (data['pages'] as num).toInt() : 1;

    return ResourcesResponseModel(
      status: status,
      success: success,
      message: message,
      resources: resources,
      docsCount: docsCount,
      pages: pages,
    );
  }
}

class CreateUpdateResourceModel extends CreateUpdateResourceEntity {
  const CreateUpdateResourceModel({
    required super.title,
    required super.body,
    required super.postCategory,
    super.isFeatured = false,
    super.approxReadTimeInMinutes = 1,
    super.featuredImageDataURI,
    super.galleryDataURIs,
  });

  factory CreateUpdateResourceModel.fromEntity(
      CreateUpdateResourceEntity entity) {
    return CreateUpdateResourceModel(
      title: entity.title,
      body: entity.body,
      postCategory: entity.postCategory,
      isFeatured: entity.isFeatured,
      approxReadTimeInMinutes: entity.approxReadTimeInMinutes,
      featuredImageDataURI: entity.featuredImageDataURI,
      galleryDataURIs: entity.galleryDataURIs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'postCategory': postCategory,
      'isFeatured': isFeatured,
      'approxReadTimeInMinutes': approxReadTimeInMinutes,
      if (featuredImageDataURI != null &&
          featuredImageDataURI!.trim().isNotEmpty)
        'featuredImageDataURI': featuredImageDataURI!.trim(),
      if (galleryDataURIs != null && galleryDataURIs!.isNotEmpty)
        'galleryDataURIs': galleryDataURIs,
    };
  }
}
