import '../../../../app/config/api_endpoints.dart';
import '../../../../core/network/api_services.dart';
import '../../../../core/network/models/response/response.dart';

abstract class PetGalleryRemoteDataSource {
  Future<Response> getPetGalleryByUserId(String userId);
}

class PetGalleryRemoteDataSourceImpl implements PetGalleryRemoteDataSource {
  final ApiServices apiServices;

  PetGalleryRemoteDataSourceImpl({required this.apiServices});

  @override
  Future<Response> getPetGalleryByUserId(String userId) {
    return apiServices.getData(
      ApiEndpoints.petGalleryByUser(userId),
    );
  }
}
