import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/pet_parent_entity.dart';
import '../../domain/repositories/pet_parents_repository.dart';
import '../data_sources/pet_parents_remote_data_source.dart';
import '../models/pet_parent_model.dart';

class PetParentsRepositoryImpl implements PetParentsRepository {
  final PetParentsRemoteDataSource remoteDataSource;

  const PetParentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PetParentsListResponseEntity> getPetParents({
    int page = 1,
    int pageSize = 10,
    String? keyword,
  }) async {
    final Response response = await remoteDataSource.getPetParents(
      page: page,
      pageSize: pageSize,
      keyword: keyword,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return PetParentsListResponseModel.fromJson(rawResponse);
  }

  @override
  Future<PetParentDetailResponseEntity> getPetParentDetail(String id) async {
    final Response response = await remoteDataSource.getPetParentDetail(id);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return PetParentDetailResponseModel.fromJson(rawResponse);
  }
}
