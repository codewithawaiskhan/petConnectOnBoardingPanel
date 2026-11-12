class InfluencerEntity {
  final String id;
  final int autoIncrementId;
  final String longAutoIncrementId;
  final String fullName;
  final String email;
  final String? username;
  final String status;
  final String createdAt;

  const InfluencerEntity({
    required this.id,
    this.autoIncrementId = 0,
    required this.longAutoIncrementId,
    required this.fullName,
    required this.email,
    this.username,
    required this.status,
    required this.createdAt,
  });
}

class InfluencerListResponseEntity {
  final bool success;
  final String message;
  final List<InfluencerEntity> docs;
  final int docsCount;
  final int totalPages;
  final int currentPage;

  const InfluencerListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
    required this.docsCount,
    required this.totalPages,
    required this.currentPage,
  });
}

class ReferredUserLookupEntity {
  final String id;
  final String fullName;
  final String? email;
  final String? image;
  final String? referralCode;

  const ReferredUserLookupEntity({
    required this.id,
    required this.fullName,
    this.email,
    this.image,
    this.referralCode,
  });
}

