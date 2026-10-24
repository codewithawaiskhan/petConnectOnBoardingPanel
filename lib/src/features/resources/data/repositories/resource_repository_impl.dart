import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/resource_entity.dart';
import '../../domain/repositories/resource_repository.dart';
import '../data_sources/resource_remote_data_source.dart';
import '../models/resource_model.dart';

class ResourceRepositoryImpl implements ResourceRepository {
  final ResourceRemoteDataSource remoteDataSource;

  const ResourceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ResourcesResponseEntity> getResources({
    int page = 1,
    int pageSize = 10,
    String? postCategory,
    String? keyword,
    String? sortBy,
  }) async {
    final Response response = await remoteDataSource.getResources(
      page: page,
      pageSize: pageSize,
      postCategory: postCategory,
      keyword: keyword,
      sortBy: sortBy,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return ResourcesResponseModel.fromJson(rawResponse);
  }

  @override
  Future<ResourceEntity> getResourceDetail(String id) async {
    final Response response = await remoteDataSource.getResourceDetail(id);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('doc') && data['doc'] is Map<String, dynamic>) {
        return ResourceModel.fromJson(data['doc'] as Map<String, dynamic>)
            .toEntity();
      }
      return ResourceModel.fromJson(data).toEntity();
    }

    return ResourceModel.fromJson(rawResponse).toEntity();
  }

  @override
  Future<ResourceEntity> addResource(CreateUpdateResourceEntity entity) async {
    final model = CreateUpdateResourceModel.fromEntity(entity);
    final Response response = await remoteDataSource.addResource(model.toJson());

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('doc') && data['doc'] is Map<String, dynamic>) {
        return ResourceModel.fromJson(data['doc'] as Map<String, dynamic>)
            .toEntity();
      } else if (data.containsKey('_id') || data.containsKey('id')) {
        return ResourceModel.fromJson(data).toEntity();
      }
    }

    return ResourceEntity(
      id: rawResponse['_id']?.toString() ?? '',
      title: entity.title,
      body: entity.body,
      categoryId: entity.postCategory,
      isFeatured: entity.isFeatured,
      approxReadTimeInMinutes: entity.approxReadTimeInMinutes,
    );
  }

  @override
  Future<ResourceEntity> updateResource(
    String id,
    CreateUpdateResourceEntity entity,
  ) async {
    final model = CreateUpdateResourceModel.fromEntity(entity);
    final Response response =
        await remoteDataSource.updateResource(id, model.toJson());

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('doc') && data['doc'] is Map<String, dynamic>) {
        return ResourceModel.fromJson(data['doc'] as Map<String, dynamic>)
            .toEntity();
      } else if (data.containsKey('_id') || data.containsKey('id')) {
        return ResourceModel.fromJson(data).toEntity();
      }
    }

    return ResourceEntity(
      id: id,
      title: entity.title,
      body: entity.body,
      categoryId: entity.postCategory,
      isFeatured: entity.isFeatured,
      approxReadTimeInMinutes: entity.approxReadTimeInMinutes,
    );
  }

  @override
  Future<void> deleteResource(String id) async {
    await remoteDataSource.deleteResource(id);
  }
}
