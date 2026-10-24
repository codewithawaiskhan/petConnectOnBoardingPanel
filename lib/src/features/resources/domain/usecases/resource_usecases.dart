import '../entities/resource_entity.dart';
import '../repositories/resource_repository.dart';

class ResourceUseCases {
  final ResourceRepository repository;

  const ResourceUseCases({required this.repository});

  Future<ResourcesResponseEntity> getResources({
    int page = 1,
    int pageSize = 10,
    String? postCategory,
    String? keyword,
    String? sortBy,
  }) {
    return repository.getResources(
      page: page,
      pageSize: pageSize,
      postCategory: postCategory,
      keyword: keyword,
      sortBy: sortBy,
    );
  }

  Future<ResourceEntity> getResourceDetail(String id) {
    return repository.getResourceDetail(id);
  }

  Future<ResourceEntity> addResource(CreateUpdateResourceEntity entity) {
    return repository.addResource(entity);
  }

  Future<ResourceEntity> updateResource(
    String id,
    CreateUpdateResourceEntity entity,
  ) {
    return repository.updateResource(id, entity);
  }

  Future<void> deleteResource(String id) {
    return repository.deleteResource(id);
  }
}
