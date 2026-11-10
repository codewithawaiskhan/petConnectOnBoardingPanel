import '../../domain/entities/withdrawal_request_entity.dart';

class WithdrawalUserIdModel extends WithdrawalUserIdEntity {
  const WithdrawalUserIdModel({
    required super.id,
    super.image,
    super.status,
    super.roles = const [],
  });

  factory WithdrawalUserIdModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalUserIdModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
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
      'image': image,
      'status': status,
      'roles': roles,
    };
  }

  WithdrawalUserIdEntity toEntity() {
    return WithdrawalUserIdEntity(
      id: id,
      image: image,
      status: status,
      roles: List<String>.from(roles),
    );
  }
}

class WithdrawalUserModel extends WithdrawalUserEntity {
  const WithdrawalUserModel({
    super.userId,
    required super.email,
  });

  factory WithdrawalUserModel.fromJson(Map<String, dynamic> json) {
    final rawUserId = json['userId'];
    WithdrawalUserIdEntity? parsedUserId;
    if (rawUserId is Map<String, dynamic>) {
      parsedUserId = WithdrawalUserIdModel.fromJson(rawUserId).toEntity();
    } else if (rawUserId != null) {
      parsedUserId = WithdrawalUserIdEntity(id: rawUserId.toString());
    }

    return WithdrawalUserModel(
      userId: parsedUserId,
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null)
        'userId': userId is WithdrawalUserIdModel
            ? (userId as WithdrawalUserIdModel).toJson()
            : {
                '_id': userId!.id,
                'image': userId!.image,
                'status': userId!.status,
                'roles': userId!.roles,
              },
      'email': email,
    };
  }

  WithdrawalUserEntity toEntity() {
    return WithdrawalUserEntity(
      userId: userId,
      email: email,
    );
  }
}

class WithdrawalRequestModel extends WithdrawalRequestEntity {
  const WithdrawalRequestModel({
    required super.id,
    required super.autoIncrementId,
    required super.type,
    super.productId,
    required super.amount,
    required super.currencyCode,
    required super.accountNumber,
    required super.status,
    super.failedReason,
    super.isDeleted = false,
    required super.createdAt,
    required super.updatedAt,
    super.user,
  });

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    final rawAutoId = json['autoIncrementId'];
    final parsedAutoId = rawAutoId is int
        ? rawAutoId
        : int.tryParse(rawAutoId?.toString() ?? '') ?? 0;

    final rawAmount = json['amount'];
    final parsedAmount = rawAmount is num
        ? rawAmount
        : num.tryParse(rawAmount?.toString() ?? '') ?? 0;

    return WithdrawalRequestModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      autoIncrementId: parsedAutoId,
      type: json['type']?.toString() ?? '',
      productId: json['productId']?.toString(),
      amount: parsedAmount,
      currencyCode: json['currencyCode']?.toString() ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      failedReason: json['failedReason']?.toString(),
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
      user: json['user'] is Map<String, dynamic>
          ? WithdrawalUserModel.fromJson(
              json['user'] as Map<String, dynamic>,
            ).toEntity()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'autoIncrementId': autoIncrementId,
      'type': type,
      'productId': productId,
      'amount': amount,
      'currencyCode': currencyCode,
      'accountNumber': accountNumber,
      'status': status,
      'failedReason': failedReason,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (user != null)
        'user': user is WithdrawalUserModel
            ? (user as WithdrawalUserModel).toJson()
            : {
                if (user!.userId != null)
                  'userId': {
                    '_id': user!.userId!.id,
                    'image': user!.userId!.image,
                    'status': user!.userId!.status,
                    'roles': user!.userId!.roles,
                  },
                'email': user!.email,
              },
    };
  }

  WithdrawalRequestEntity toEntity() {
    return WithdrawalRequestEntity(
      id: id,
      autoIncrementId: autoIncrementId,
      type: type,
      productId: productId,
      amount: amount,
      currencyCode: currencyCode,
      accountNumber: accountNumber,
      status: status,
      failedReason: failedReason,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      user: user,
    );
  }
}

class WithdrawalListResponseModel extends WithdrawalListResponseEntity {
  const WithdrawalListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
    required super.docsCount,
    required super.totalPages,
    required super.currentPage,
  });

  factory WithdrawalListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final rawDocs = data['docs'] as List<dynamic>? ?? <dynamic>[];

    final List<WithdrawalRequestEntity> parsedDocs = rawDocs
        .whereType<Map<String, dynamic>>()
        .map<WithdrawalRequestEntity>(
          (e) => WithdrawalRequestModel.fromJson(e).toEntity(),
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

    final dynamic rawTotalPages = data['totalPages'] ??
        data['pages'] ??
        json['totalPages'] ??
        json['pages'];

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

    return WithdrawalListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
      docsCount: parsedDocsCount,
      totalPages: parsedTotalPages > 0 ? parsedTotalPages : 1,
      currentPage: parsedCurrentPage > 0 ? parsedCurrentPage : 1,
    );
  }

  WithdrawalListResponseEntity toEntity() {
    return WithdrawalListResponseEntity(
      success: success,
      message: message,
      docs: List<WithdrawalRequestEntity>.from(docs),
      docsCount: docsCount,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}
