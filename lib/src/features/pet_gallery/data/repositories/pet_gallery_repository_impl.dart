import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/pet_gallery_entity.dart';
import '../../domain/repositories/pet_gallery_repository.dart';
import '../data_sources/pet_gallery_remote_data_source.dart';
import '../models/pet_gallery_model.dart';

class PetGalleryRepositoryImpl implements PetGalleryRepository {
  final PetGalleryRemoteDataSource remoteDataSource;

  const PetGalleryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PetGalleryEntity>> getPetGalleryByUserId(String userId) async {
    final Response response =
        await remoteDataSource.getPetGalleryByUserId(userId);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    List rawDocs = const [];
    final data = rawResponse['data'];

    if (data is Map<String, dynamic>) {
      if (data['docs'] is List) {
        rawDocs = data['docs'] as List;
      } else if (data['gallery'] is List) {
        rawDocs = data['gallery'] as List;
      }
    } else if (data is List) {
      rawDocs = data;
    } else if (rawResponse['docs'] is List) {
      rawDocs = rawResponse['docs'] as List;
    } else if (rawResponse['gallery'] is List) {
      rawDocs = rawResponse['gallery'] as List;
    }

    // STRICT CLEAN ARCHITECTURE TYPE RULE 6:
    // ALWAYS explicitly map as `.map<PetGalleryEntity>(...)`
    return rawDocs
        .whereType<Map<String, dynamic>>()
        .map<PetGalleryEntity>((doc) => PetGalleryModel.fromJson(doc).toEntity())
        .toList();
  }
}
