import '../../domain/entities/marketing_company_entity.dart';

class MarketingCompanyUserIdModel extends MarketingCompanyUserIdEntity {
  const MarketingCompanyUserIdModel({
    required super.id,
    super.fullName,
    super.username,
    super.image,
    super.status,
    super.roles = const [],
  });

  factory MarketingCompanyUserIdModel.fromJson(Map<String, dynamic> json) {
    return MarketingCompanyUserIdModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString(),
      username: json['username']?.toString(),
      image: json['image']?.toString(),
      status: json['status']?.toString(),
      roles:
          (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'username': username,
      'image': image,
      'status': status,
      'roles': roles,
    };
  }

  MarketingCompanyUserIdEntity toEntity() {
    return MarketingCompanyUserIdEntity(
      id: id,
      fullName: fullName,
      username: username,
      image: image,
      status: status,
      roles: List<String>.from(roles),
    );
  }
}

class MarketingCompanyUserModel extends MarketingCompanyUserEntity {
  const MarketingCompanyUserModel({
    super.userId,
    required super.email,
  });

  factory MarketingCompanyUserModel.fromJson(Map<String, dynamic> json) {
    final rawUserId = json['userId'];
    MarketingCompanyUserIdEntity? parsedUserId;
    if (rawUserId is Map<String, dynamic>) {
      parsedUserId =
          MarketingCompanyUserIdModel.fromJson(rawUserId).toEntity();
    } else if (rawUserId != null) {
      parsedUserId = MarketingCompanyUserIdEntity(id: rawUserId.toString());
    }

    return MarketingCompanyUserModel(
      userId: parsedUserId,
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null)
        'userId': userId is MarketingCompanyUserIdModel
            ? (userId as MarketingCompanyUserIdModel).toJson()
            : {
                '_id': userId!.id,
                'fullName': userId!.fullName,
                'username': userId!.username,
                'image': userId!.image,
                'status': userId!.status,
                'roles': userId!.roles,
              },
      'email': email,
    };
  }

  MarketingCompanyUserEntity toEntity() {
    return MarketingCompanyUserEntity(
      userId: userId,
      email: email,
    );
  }
}

class MarketingCompanyModel extends MarketingCompanyEntity {
  const MarketingCompanyModel({
    required super.id,
    required super.autoIncrementId,
    required super.longAutoIncrementId,
    required super.displayName,
    required super.legalName,
    required super.status,
    required super.revenueShare,
    super.isDeleted = false,
    required super.createdAt,
    required super.updatedAt,
    super.user,
  });

  factory MarketingCompanyModel.fromJson(Map<String, dynamic> json) {
    final rawAutoId = json['autoIncrementId'];
    final parsedAutoId = rawAutoId is int
        ? rawAutoId
        : int.tryParse(rawAutoId?.toString() ?? '') ?? 0;

    final rawRevenueShare = json['revenueShare'];
    final parsedRevenueShare = rawRevenueShare is num
        ? rawRevenueShare
        : num.tryParse(rawRevenueShare?.toString() ?? '') ?? 0;

    return MarketingCompanyModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      autoIncrementId: parsedAutoId,
      longAutoIncrementId: json['longAutoIncrementId']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      legalName: json['legalName']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      revenueShare: parsedRevenueShare,
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      user: json['user'] is Map<String, dynamic>
          ? MarketingCompanyUserModel.fromJson(
              json['user'] as Map<String, dynamic>,
            ).toEntity()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'autoIncrementId': autoIncrementId,
      'longAutoIncrementId': longAutoIncrementId,
      'displayName': displayName,
      'legalName': legalName,
      'status': status,
      'revenueShare': revenueShare,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (user != null)
        'user': user is MarketingCompanyUserModel
            ? (user as MarketingCompanyUserModel).toJson()
            : {
                if (user!.userId != null)
                  'userId': {
                    '_id': user!.userId!.id,
                    'fullName': user!.userId!.fullName,
                    'username': user!.userId!.username,
                    'image': user!.userId!.image,
                    'status': user!.userId!.status,
                    'roles': user!.userId!.roles,
                  },
                'email': user!.email,
              },
    };
  }

  MarketingCompanyEntity toEntity() {
    return MarketingCompanyEntity(
      id: id,
      autoIncrementId: autoIncrementId,
      longAutoIncrementId: longAutoIncrementId,
      displayName: displayName,
      legalName: legalName,
      status: status,
      revenueShare: revenueShare,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: user,
    );
  }
}

class MarketingCompanyListResponseModel
    extends MarketingCompanyListResponseEntity {
  const MarketingCompanyListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
    required super.docsCount,
    required super.totalPages,
    required super.currentPage,
  });

  factory MarketingCompanyListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final rawDocs = data['docs'] as List<dynamic>? ?? <dynamic>[];

    final List<MarketingCompanyEntity> parsedDocs = rawDocs
        .whereType<Map<String, dynamic>>()
        .map<MarketingCompanyEntity>(
          (e) => MarketingCompanyModel.fromJson(e).toEntity(),
        )
        .toList();

    final dynamic rawDocsCount = data['docsCount'] ??
        data['totalDocs'] ??
        data['total'] ??
        data['count'] ??
        json['docsCount'] ??
        json['totalDocs'] ??
        json['total'] ??
        json['count'];

    final dynamic rawTotalPages = data['pages'] ??
        data['totalPages'] ??
        json['pages'] ??
        json['totalPages'];

    final dynamic rawCurrentPage = data['currentPage'] ??
        data['page'] ??
        json['currentPage'] ??
        json['page'];

    final parsedDocsCount = rawDocsCount is int
        ? rawDocsCount
        : int.tryParse(rawDocsCount?.toString() ?? '') ?? parsedDocs.length;

    final parsedTotalPages = rawTotalPages is int
        ? rawTotalPages
        : int.tryParse(rawTotalPages?.toString() ?? '') ??
            (parsedDocsCount > 0 ? (parsedDocsCount / 10).ceil() : 1);

    final parsedCurrentPage = rawCurrentPage is int
        ? rawCurrentPage
        : int.tryParse(rawCurrentPage?.toString() ?? '') ?? 1;

    return MarketingCompanyListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
      docsCount: parsedDocsCount,
      totalPages: parsedTotalPages > 0 ? parsedTotalPages : 1,
      currentPage: parsedCurrentPage > 0 ? parsedCurrentPage : 1,
    );
  }

  MarketingCompanyListResponseEntity toEntity() {
    return MarketingCompanyListResponseEntity(
      success: success,
      message: message,
      docs: List<MarketingCompanyEntity>.from(docs),
      docsCount: docsCount,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

