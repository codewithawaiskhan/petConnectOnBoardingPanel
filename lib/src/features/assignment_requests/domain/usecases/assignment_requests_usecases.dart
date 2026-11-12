import '../entities/assignment_request_entity.dart';
import '../repositories/assignment_requests_repository.dart';

class GetAssignmentRequestsUseCase {
  final AssignmentRequestsRepository repository;

  const GetAssignmentRequestsUseCase({required this.repository});

  Future<AssignmentRequestListResponseEntity> call(
    Map<String, dynamic> queryParams,
  ) {
    return repository.getAssignmentRequests(queryParams);
  }
}

class UpdateAssignmentRequestStatusUseCase {
  final AssignmentRequestsRepository repository;

  const UpdateAssignmentRequestStatusUseCase({required this.repository});

  Future<void> call({
    required String id,
    required String status,
  }) {
    return repository.updateRequestStatus(id: id, status: status);
  }
}

