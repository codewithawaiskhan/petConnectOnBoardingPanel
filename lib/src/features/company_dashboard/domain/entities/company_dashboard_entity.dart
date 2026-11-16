class MarketingCompanySummaryEntity {
  final String id;
  final String displayName;

  const MarketingCompanySummaryEntity({
    required this.id,
    required this.displayName,
  });

  const MarketingCompanySummaryEntity.empty()
      : id = '',
        displayName = '';
}

class CompanyDashboardEntity {
  final MarketingCompanySummaryEntity marketingCompany;
  final int activeInfluencersCount;
  final int convertedUsersCount;
  final int convertedUsersCountAndroid;
  final int convertedUsersCountiOS;
  final int nonconvertedUsersCount;
  final int nonconvertedUsersCountAndroid;
  final int nonconvertedUsersCountiOS;
  final num combinedConversionRate;
  final num combinedConversionRateAndroid;
  final num combinedConversionRateiOS;
  final num grossEarnings;
  final num refunds;
  final num netEarnings;
  final String currencyCode;

  const CompanyDashboardEntity({
    required this.marketingCompany,
    required this.activeInfluencersCount,
    required this.convertedUsersCount,
    required this.convertedUsersCountAndroid,
    required this.convertedUsersCountiOS,
    required this.nonconvertedUsersCount,
    required this.nonconvertedUsersCountAndroid,
    required this.nonconvertedUsersCountiOS,
    required this.combinedConversionRate,
    required this.combinedConversionRateAndroid,
    required this.combinedConversionRateiOS,
    required this.grossEarnings,
    required this.refunds,
    required this.netEarnings,
    required this.currencyCode,
  });

  const CompanyDashboardEntity.empty()
      : marketingCompany = const MarketingCompanySummaryEntity.empty(),
        activeInfluencersCount = 0,
        convertedUsersCount = 0,
        convertedUsersCountAndroid = 0,
        convertedUsersCountiOS = 0,
        nonconvertedUsersCount = 0,
        nonconvertedUsersCountAndroid = 0,
        nonconvertedUsersCountiOS = 0,
        combinedConversionRate = 0,
        combinedConversionRateAndroid = 0,
        combinedConversionRateiOS = 0,
        grossEarnings = 0,
        refunds = 0,
        netEarnings = 0,
        currencyCode = 'USD';
}

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
