import '../../domain/entities/assignment_request_entity.dart';

class AssignmentCompanyModel extends AssignmentCompanyEntity {
  const AssignmentCompanyModel({
    required super.marketingCompanyId,
    required super.displayName,
  });

  factory AssignmentCompanyModel.fromJson(Map<String, dynamic> json) {
    return AssignmentCompanyModel(
      marketingCompanyId: json['marketingCompanyId']?.toString() ??
          json['_id']?.toString() ??
          '',
      displayName: json['displayName']?.toString() ?? '',
    );
  }

  AssignmentCompanyEntity toEntity() {
    return AssignmentCompanyEntity(
      marketingCompanyId: marketingCompanyId,
      displayName: displayName,
    );
  }
}

class AssignmentRequestUserModel extends AssignmentRequestUserEntity {
  const AssignmentRequestUserModel({
    required super.id,
    required super.fullName,
    super.username,
    required super.email,
    super.image,
    super.status,
    super.roles = const [],
  });

  factory AssignmentRequestUserModel.fromJson(Map<String, dynamic> json) {
    return AssignmentRequestUserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      username: json['username']?.toString(),
      email: json['email']?.toString() ?? '',
      image: json['image']?.toString(),
      status: json['status']?.toString(),
      roles:
          (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  AssignmentRequestUserEntity toEntity() {
    return AssignmentRequestUserEntity(
      id: id,
      fullName: fullName,
      username: username,
      email: email,
      image: image,
      status: status,
      roles: List<String>.from(roles),
    );
  }
}

class AssignmentRequestModel extends AssignmentRequestEntity {
  const AssignmentRequestModel({
    required super.id,
    required super.autoIncrementId,
    super.marketingCompany,
    super.users = const [],
    required super.status,
    super.isDeleted = false,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AssignmentRequestModel.fromJson(Map<String, dynamic> json) {
    final rawAutoId = json['autoIncrementId'];
    final parsedAutoId = rawAutoId is int
        ? rawAutoId
        : int.tryParse(rawAutoId?.toString() ?? '') ?? 0;

    final rawUsers = json['users'] as List<dynamic>? ?? <dynamic>[];
    final parsedUsers = rawUsers
        .whereType<Map<String, dynamic>>()
        .map<AssignmentRequestUserEntity>(
          (e) => AssignmentRequestUserModel.fromJson(e).toEntity(),
        )
        .toList();

    return AssignmentRequestModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      autoIncrementId: parsedAutoId,
      marketingCompany: json['marketingCompany'] is Map<String, dynamic>
          ? AssignmentCompanyModel.fromJson(
              json['marketingCompany'] as Map<String, dynamic>,
            ).toEntity()
          : null,
      users: parsedUsers,
      status: json['status']?.toString() ?? '',
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  AssignmentRequestEntity toEntity() {
    return AssignmentRequestEntity(
      id: id,
      autoIncrementId: autoIncrementId,
      marketingCompany: marketingCompany,
      users: List<AssignmentRequestUserEntity>.from(users),
      status: status,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class AssignmentRequestListResponseModel
    extends AssignmentRequestListResponseEntity {
  const AssignmentRequestListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
    required super.docsCount,
    required super.totalPages,
    required super.currentPage,
  });

  factory AssignmentRequestListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final rawDocs = data['docs'] as List<dynamic>? ?? <dynamic>[];

    final List<AssignmentRequestEntity> parsedDocs = rawDocs
        .whereType<Map<String, dynamic>>()
        .map<AssignmentRequestEntity>(
          (e) => AssignmentRequestModel.fromJson(e).toEntity(),
        )
        .toList();

    final dynamic rawDocsCount = data['docsCount'] ??
        data['totalDocs'] ??
        data['total'] ??
        data['count'] ??
        json['docsCount'];
    final dynamic rawPages =
        data['pages'] ?? data['totalPages'] ?? json['pages'];
    final dynamic rawPage =
        data['currentPage'] ?? data['page'] ?? json['currentPage'];

    final parsedDocsCount = rawDocsCount is int
        ? rawDocsCount
        : int.tryParse(rawDocsCount?.toString() ?? '') ?? parsedDocs.length;
    final parsedPages = rawPages is int
        ? rawPages
        : int.tryParse(rawPages?.toString() ?? '') ?? 1;
    final parsedPage = rawPage is int
        ? rawPage
        : int.tryParse(rawPage?.toString() ?? '') ?? 1;

    return AssignmentRequestListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
      docsCount: parsedDocsCount,
      totalPages: parsedPages > 0 ? parsedPages : 1,
      currentPage: parsedPage > 0 ? parsedPage : 1,
    );
  }

  AssignmentRequestListResponseEntity toEntity() {
    return AssignmentRequestListResponseEntity(
      success: success,
      message: message,
      docs: List<AssignmentRequestEntity>.from(docs),
      docsCount: docsCount,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

