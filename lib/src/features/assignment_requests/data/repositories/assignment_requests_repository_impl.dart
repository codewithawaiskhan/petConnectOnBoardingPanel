import '../../../../core/network/models/response/response.dart';
import '../../domain/entities/assignment_request_entity.dart';
import '../../domain/repositories/assignment_requests_repository.dart';
import '../data_sources/assignment_requests_remote_data_source.dart';
import '../models/assignment_request_model.dart';

class AssignmentRequestsRepositoryImpl implements AssignmentRequestsRepository {
  final AssignmentRequestsRemoteDataSource remoteDataSource;

  const AssignmentRequestsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AssignmentRequestListResponseEntity> getAssignmentRequests(
    Map<String, dynamic> queryParams,
  ) async {
    final Response response = await remoteDataSource.getAssignmentRequests(
      queryParams,
    );

    final Map<String, dynamic> rawResponse =
        response.body is Map<String, dynamic>
            ? response.body as Map<String, dynamic>
            : <String, dynamic>{};

    return AssignmentRequestListResponseModel.fromJson(rawResponse).toEntity();
  }

  @override
  Future<void> updateRequestStatus({
    required String id,
    required String status,
  }) async {
    await remoteDataSource.updateRequestStatus(id, {'status': status});
  }
}

