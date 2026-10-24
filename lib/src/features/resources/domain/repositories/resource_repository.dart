import '../entities/resource_entity.dart';

abstract class ResourceRepository {
  Future<ResourcesResponseEntity> getResources({
    int page = 1,
    int pageSize = 10,
    String? postCategory,
    String? keyword,
    String? sortBy,
  });

  Future<ResourceEntity> getResourceDetail(String id);
  Future<ResourceEntity> addResource(CreateUpdateResourceEntity entity);
  Future<ResourceEntity> updateResource(
    String id,
    CreateUpdateResourceEntity entity,
  );
  Future<void> deleteResource(String id);
}
