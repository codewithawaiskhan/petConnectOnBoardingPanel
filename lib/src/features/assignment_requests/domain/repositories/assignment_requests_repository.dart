import '../entities/assignment_request_entity.dart';

abstract class AssignmentRequestsRepository {
  Future<AssignmentRequestListResponseEntity> getAssignmentRequests(
    Map<String, dynamic> queryParams,
  );

  Future<void> updateRequestStatus({
    required String id,
    required String status,
  });
}

