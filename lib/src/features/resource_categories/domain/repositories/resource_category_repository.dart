import '../entities/resource_category_entity.dart';

abstract class ResourceCategoryRepository {
  Future<ResourceCategoriesResponseEntity> getCategories({
    String sortBy = "createdAt_ascending",
  });

  Future<ResourceCategoryEntity> addCategory({
    required String title,
    String? iconDataURI,
  });

  Future<ResourceCategoryEntity> updateCategory({
    required String id,
    required String title,
    String? iconDataURI,
  });

  Future<void> deleteCategory(String id);
}
