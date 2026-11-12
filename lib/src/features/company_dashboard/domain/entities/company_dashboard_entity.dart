class CompanyProfileEntity {
  final String id;
  final int autoIncrementId;
  final String longAutoIncrementId;
  final String displayName;
  final String legalName;
  final num revenueShare;
  final String status;
  final String email;
  final String createdAt;

  const CompanyProfileEntity({
    required this.id,
    this.autoIncrementId = 0,
    this.longAutoIncrementId = '',
    required this.displayName,
    required this.legalName,
    required this.revenueShare,
    required this.status,
    required this.email,
    required this.createdAt,
  });

  const CompanyProfileEntity.empty()
    : id = '',
      autoIncrementId = 0,
      longAutoIncrementId = '',
      displayName = '',
      legalName = '',
      revenueShare = 0,
      status = '',
      email = '',
      createdAt = '';
}

class ReferralStatsEntity {
  final int totalReferredUsers;
  final int convertedReferredUsers;
  final int nonconvertedReferredUsers;

  const ReferralStatsEntity({
    required this.totalReferredUsers,
    required this.convertedReferredUsers,
    required this.nonconvertedReferredUsers,
  });

  const ReferralStatsEntity.empty()
    : totalReferredUsers = 0,
      convertedReferredUsers = 0,
      nonconvertedReferredUsers = 0;
}

