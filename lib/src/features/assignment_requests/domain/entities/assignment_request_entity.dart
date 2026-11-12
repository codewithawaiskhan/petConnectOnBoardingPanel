class AssignmentCompanyEntity {
  final String marketingCompanyId;
  final String displayName;

  const AssignmentCompanyEntity({
    required this.marketingCompanyId,
    required this.displayName,
  });
}

class AssignmentRequestUserEntity {
  final String id;
  final String fullName;
  final String? username;
  final String email;
  final String? image;
  final String? status;
  final List<String> roles;

  const AssignmentRequestUserEntity({
    required this.id,
    required this.fullName,
    this.username,
    required this.email,
    this.image,
    this.status,
    this.roles = const [],
  });
}

class AssignmentRequestEntity {
  final String id;
  final int autoIncrementId;
  final AssignmentCompanyEntity? marketingCompany;
  final List<AssignmentRequestUserEntity> users;
  final String status;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  const AssignmentRequestEntity({
    required this.id,
    required this.autoIncrementId,
    this.marketingCompany,
    this.users = const [],
    required this.status,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  AssignmentRequestEntity copyWith({
    String? status,
  }) {
    return AssignmentRequestEntity(
      id: id,
      autoIncrementId: autoIncrementId,
      marketingCompany: marketingCompany,
      users: users,
      status: status ?? this.status,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class AssignmentRequestListResponseEntity {
  final bool success;
  final String message;
  final List<AssignmentRequestEntity> docs;
  final int docsCount;
  final int totalPages;
  final int currentPage;

  const AssignmentRequestListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
    required this.docsCount,
    required this.totalPages,
    required this.currentPage,
  });
}

