import '../entities/resource_category_entity.dart';
import '../repositories/resource_category_repository.dart';

class ResourceCategoryUseCases {
  final ResourceCategoryRepository repository;

  const ResourceCategoryUseCases({required this.repository});

  Future<ResourceCategoriesResponseEntity> getCategories({
    String sortBy = "createdAt_ascending",
  }) {
    return repository.getCategories(sortBy: sortBy);
  }

  Future<ResourceCategoryEntity> addCategory({
    required String title,
    String? iconDataURI,
  }) {
    return repository.addCategory(
      title: title,
      iconDataURI: iconDataURI,
    );
  }

  Future<ResourceCategoryEntity> updateCategory({
    required String id,
    required String title,
    String? iconDataURI,
  }) {
    return repository.updateCategory(
      id: id,
      title: title,
      iconDataURI: iconDataURI,
    );
  }

  Future<void> deleteCategory(String id) {
    return repository.deleteCategory(id);
  }
}
