class MarketingCompanyUserIdEntity {
  final String id;
  final String? fullName;
  final String? username;
  final String? image;
  final String? status;
  final List<String> roles;

  const MarketingCompanyUserIdEntity({
    required this.id,
    this.fullName,
    this.username,
    this.image,
    this.status,
    this.roles = const [],
  });
}

class MarketingCompanyUserEntity {
  final MarketingCompanyUserIdEntity? userId;
  final String email;

  const MarketingCompanyUserEntity({
    this.userId,
    required this.email,
  });
}

class MarketingCompanyEntity {
  final String id;
  final int autoIncrementId;
  final String longAutoIncrementId;
  final String displayName;
  final String legalName;
  final String status;
  final num revenueShare;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final MarketingCompanyUserEntity? user;

  const MarketingCompanyEntity({
    required this.id,
    required this.autoIncrementId,
    required this.longAutoIncrementId,
    required this.displayName,
    required this.legalName,
    required this.status,
    required this.revenueShare,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });
}

class MarketingCompanyListResponseEntity {
  final bool success;
  final String message;
  final List<MarketingCompanyEntity> docs;
  final int docsCount;
  final int totalPages;
  final int currentPage;

  const MarketingCompanyListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
    required this.docsCount,
    required this.totalPages,
    required this.currentPage,
  });
}

