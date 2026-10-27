import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/pet_entity.dart';
import '../../domain/repositories/pet_repository.dart';
import '../data_sources/pet_remote_data_source.dart';
import '../models/pet_model.dart';

class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource remoteDataSource;

  const PetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PetEntity>> getPetsByParentId(String parentId) async {
    final Response response = await remoteDataSource.getPetsByParentId(parentId);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    List rawDocs = const [];
    final data = rawResponse['data'];

    if (data is Map<String, dynamic>) {
      if (data['docs'] is List) {
        rawDocs = data['docs'] as List;
      } else if (data['pets'] is List) {
        rawDocs = data['pets'] as List;
      }
    } else if (data is List) {
      rawDocs = data;
    } else if (rawResponse['docs'] is List) {
      rawDocs = rawResponse['docs'] as List;
    } else if (rawResponse['pets'] is List) {
      rawDocs = rawResponse['pets'] as List;
    }

    // STRICT CLEAN ARCHITECTURE TYPE RULE 6:
    // ALWAYS explicitly map as `.map<PetEntity>(...)`
    return rawDocs
        .whereType<Map<String, dynamic>>()
        .map<PetEntity>((doc) => PetModel.fromJson(doc).toEntity())
        .toList();
  }
}
