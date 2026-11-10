class WithdrawalUserIdEntity {
  final String id;
  final String? image;
  final String? status;
  final List<String> roles;

  const WithdrawalUserIdEntity({
    required this.id,
    this.image,
    this.status,
    this.roles = const [],
  });
}

class WithdrawalUserEntity {
  final WithdrawalUserIdEntity? userId;
  final String email;

  const WithdrawalUserEntity({
    this.userId,
    required this.email,
  });
}

class WithdrawalRequestEntity {
  final String id;
  final int autoIncrementId;
  final String type;
  final String? productId;
  final num amount;
  final String currencyCode;
  final String accountNumber;
  final String status;
  final String? failedReason;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final WithdrawalUserEntity? user;

  const WithdrawalRequestEntity({
    required this.id,
    required this.autoIncrementId,
    required this.type,
    this.productId,
    required this.amount,
    required this.currencyCode,
    required this.accountNumber,
    required this.status,
    this.failedReason,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });
}

class WithdrawalListResponseEntity {
  final bool success;
  final String message;
  final List<WithdrawalRequestEntity> docs;
  final int docsCount;
  final int totalPages;
  final int currentPage;

  const WithdrawalListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
    required this.docsCount,
    required this.totalPages,
    required this.currentPage,
  });
}
