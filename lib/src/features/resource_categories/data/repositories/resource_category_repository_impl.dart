import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/resource_category_entity.dart';
import '../../domain/repositories/resource_category_repository.dart';
import '../data_sources/resource_category_remote_data_source.dart';
import '../models/resource_category_model.dart';

class ResourceCategoryRepositoryImpl implements ResourceCategoryRepository {
  final ResourceCategoryRemoteDataSource remoteDataSource;

  const ResourceCategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ResourceCategoriesResponseEntity> getCategories({
    String sortBy = "createdAt_ascending",
  }) async {
    final Response response = await remoteDataSource.getCategories(
      sortBy: sortBy,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return ResourceCategoriesResponseModel.fromJson(rawResponse);
  }

  @override
  Future<ResourceCategoryEntity> addCategory({
    required String title,
    String? iconDataURI,
  }) async {
    final Map<String, dynamic> body = {
      'title': title.trim(),
      if (iconDataURI != null && iconDataURI.trim().isNotEmpty)
        'iconDataURI': iconDataURI.trim(),
    };

    final Response response = await remoteDataSource.addCategory(body);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('_id') || data.containsKey('id')) {
        return ResourceCategoryModel.fromJson(data).toEntity();
      } else if (data['category'] is Map<String, dynamic>) {
        return ResourceCategoryModel.fromJson(
          data['category'] as Map<String, dynamic>,
        ).toEntity();
      } else if (data['doc'] is Map<String, dynamic>) {
        return ResourceCategoryModel.fromJson(
          data['doc'] as Map<String, dynamic>,
        ).toEntity();
      }
    }

    return ResourceCategoryEntity(
      id: rawResponse['_id']?.toString() ?? '',
      title: title,
    );
  }

  @override
  Future<ResourceCategoryEntity> updateCategory({
    required String id,
    required String title,
    String? iconDataURI,
  }) async {
    final Map<String, dynamic> body = {
      'title': title.trim(),
      if (iconDataURI != null && iconDataURI.trim().isNotEmpty)
        'iconDataURI': iconDataURI.trim(),
    };

    final Response response = await remoteDataSource.updateCategory(id, body);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    final data = rawResponse['data'];
    if (data is Map<String, dynamic>) {
      if (data.containsKey('_id') || data.containsKey('id')) {
        return ResourceCategoryModel.fromJson(data).toEntity();
      } else if (data['category'] is Map<String, dynamic>) {
        return ResourceCategoryModel.fromJson(
          data['category'] as Map<String, dynamic>,
        ).toEntity();
      } else if (data['doc'] is Map<String, dynamic>) {
        return ResourceCategoryModel.fromJson(
          data['doc'] as Map<String, dynamic>,
        ).toEntity();
      }
    }

    return ResourceCategoryEntity(id: id, title: title);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await remoteDataSource.deleteCategory(id);
  }
}
