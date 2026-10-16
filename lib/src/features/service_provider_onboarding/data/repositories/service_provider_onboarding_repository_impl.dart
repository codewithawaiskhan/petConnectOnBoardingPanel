import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/service_provider_list_entity.dart';
import '../../domain/entities/service_provider_onboarding_entity.dart';
import '../../domain/entities/update_service_provider_entity.dart';
import '../../domain/repositories/service_provider_onboarding_repository.dart';
import '../data_sources/service_provider_onboarding_remote_data_source.dart';
import '../models/service_provider_list_model.dart';
import '../models/service_provider_onboarding_model.dart';
import '../models/update_service_provider_model.dart';

class ServiceProviderOnboardingRepositoryImpl
    implements ServiceProviderOnboardingRepository {
  final ServiceProviderOnboardingRemoteDataSource remoteDataSource;

  const ServiceProviderOnboardingRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<ServiceProviderDataEntryResponseEntity> submitServiceProviderDataEntry(
    ServiceProviderOnboardingEntity entity,
  ) async {
    final model = ServiceProviderOnboardingModel.fromEntity(entity);
    final Response response = await remoteDataSource
        .submitServiceProviderDataEntry(model);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return ServiceProviderDataEntryResponseModel.fromJson(rawResponse);
  }

  @override
  Future<ServiceProviderListResponseEntity> getServiceProviders({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? keyword,
  }) async {
    final Response response = await remoteDataSource.getServiceProviders(
      page: page,
      pageSize: pageSize,
      status: status,
      keyword: keyword,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return ServiceProviderListResponseModel.fromJson(rawResponse);
  }

  @override
  Future<ServiceProviderDetailResponseEntity> getServiceProviderDetail(
    String id,
  ) async {
    final Response response = await remoteDataSource.getServiceProviderDetail(
      id,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return ServiceProviderDetailResponseModel.fromJson(rawResponse);
  }

  @override
  Future<ServiceProviderActionResponseEntity> updateServiceProvider(
    String id,
    UpdateServiceProviderEntity entity,
  ) async {
    final model = UpdateServiceProviderModel.fromEntity(entity);
    final Response response = await remoteDataSource.updateServiceProvider(
      id,
      model,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return ServiceProviderActionResponseModel.fromJson(rawResponse);
  }

  @override
  Future<ServiceProviderActionResponseEntity> deleteServiceProvider(
    String id,
  ) async {
    final Response response = await remoteDataSource.deleteServiceProvider(id);

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
        ? response.body as Map<String, dynamic>
        : <String, dynamic>{};

    return ServiceProviderActionResponseModel.fromJson(rawResponse);
  }
}
