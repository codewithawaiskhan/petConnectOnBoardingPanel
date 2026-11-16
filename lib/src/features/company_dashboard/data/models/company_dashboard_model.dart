import '../../domain/entities/company_dashboard_entity.dart';

class MarketingCompanySummaryModel extends MarketingCompanySummaryEntity {
  const MarketingCompanySummaryModel({
    required super.id,
    required super.displayName,
  });

  factory MarketingCompanySummaryModel.fromJson(Map<String, dynamic> json) {
    return MarketingCompanySummaryModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'displayName': displayName,
    };
  }

  MarketingCompanySummaryEntity toEntity() {
    return MarketingCompanySummaryEntity(
      id: id,
      displayName: displayName,
    );
  }
}

class CompanyDashboardModel extends CompanyDashboardEntity {
  const CompanyDashboardModel({
    required super.marketingCompany,
    required super.activeInfluencersCount,
    required super.convertedUsersCount,
    required super.convertedUsersCountAndroid,
    required super.convertedUsersCountiOS,
    required super.nonconvertedUsersCount,
    required super.nonconvertedUsersCountAndroid,
    required super.nonconvertedUsersCountiOS,
    required super.combinedConversionRate,
    required super.combinedConversionRateAndroid,
    required super.combinedConversionRateiOS,
    required super.grossEarnings,
    required super.refunds,
    required super.netEarnings,
    required super.currencyCode,
  });

  factory CompanyDashboardModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
    num parseNum(dynamic v) =>
        v is num ? v : num.tryParse(v?.toString() ?? '') ?? 0;

    final companyJson = json['marketingCompany'] is Map<String, dynamic>
        ? json['marketingCompany'] as Map<String, dynamic>
        : <String, dynamic>{};

    return CompanyDashboardModel(
      marketingCompany: MarketingCompanySummaryModel.fromJson(companyJson).toEntity(),
      activeInfluencersCount: parseInt(json['activeInfluencersCount']),
      convertedUsersCount: parseInt(json['convertedUsersCount']),
      convertedUsersCountAndroid: parseInt(json['convertedUsersCountAndroid']),
      convertedUsersCountiOS: parseInt(json['convertedUsersCountiOS']),
      nonconvertedUsersCount: parseInt(json['nonconvertedUsersCount']),
      nonconvertedUsersCountAndroid: parseInt(json['nonconvertedUsersCountAndroid']),
      nonconvertedUsersCountiOS: parseInt(json['nonconvertedUsersCountiOS']),
      combinedConversionRate: parseNum(json['combinedConversionRate']),
      combinedConversionRateAndroid: parseNum(json['combinedConversionRateAndroid']),
      combinedConversionRateiOS: parseNum(json['combinedConversionRateiOS']),
      grossEarnings: parseNum(json['grossEarnings']),
      refunds: parseNum(json['refunds']),
      netEarnings: parseNum(json['netEarnings']),
      currencyCode: json['currencyCode']?.toString().isNotEmpty == true
          ? json['currencyCode'].toString()
          : 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'marketingCompany': {
        '_id': marketingCompany.id,
        'displayName': marketingCompany.displayName,
      },
      'activeInfluencersCount': activeInfluencersCount,
      'convertedUsersCount': convertedUsersCount,
      'convertedUsersCountAndroid': convertedUsersCountAndroid,
      'convertedUsersCountiOS': convertedUsersCountiOS,
      'nonconvertedUsersCount': nonconvertedUsersCount,
      'nonconvertedUsersCountAndroid': nonconvertedUsersCountAndroid,
      'nonconvertedUsersCountiOS': nonconvertedUsersCountiOS,
      'combinedConversionRate': combinedConversionRate,
      'combinedConversionRateAndroid': combinedConversionRateAndroid,
      'combinedConversionRateiOS': combinedConversionRateiOS,
      'grossEarnings': grossEarnings,
      'refunds': refunds,
      'netEarnings': netEarnings,
      'currencyCode': currencyCode,
    };
  }

  CompanyDashboardEntity toEntity() {
    return CompanyDashboardEntity(
      marketingCompany: marketingCompany,
      activeInfluencersCount: activeInfluencersCount,
      convertedUsersCount: convertedUsersCount,
      convertedUsersCountAndroid: convertedUsersCountAndroid,
      convertedUsersCountiOS: convertedUsersCountiOS,
      nonconvertedUsersCount: nonconvertedUsersCount,
      nonconvertedUsersCountAndroid: nonconvertedUsersCountAndroid,
      nonconvertedUsersCountiOS: nonconvertedUsersCountiOS,
      combinedConversionRate: combinedConversionRate,
      combinedConversionRateAndroid: combinedConversionRateAndroid,
      combinedConversionRateiOS: combinedConversionRateiOS,
      grossEarnings: grossEarnings,
      refunds: refunds,
      netEarnings: netEarnings,
      currencyCode: currencyCode,
    );
  }
}

class CompanyProfileModel extends CompanyProfileEntity {
  const CompanyProfileModel({
    required super.id,
    super.autoIncrementId = 0,
    super.longAutoIncrementId = '',
    required super.displayName,
    required super.legalName,
    required super.revenueShare,
    required super.status,
    required super.email,
    required super.createdAt,
  });

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : <String, dynamic>{};
    final userIdMap = userMap['userId'] is Map<String, dynamic>
        ? userMap['userId'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rawAutoId = json['autoIncrementId'];
    final parsedAutoId = rawAutoId is int
        ? rawAutoId
        : int.tryParse(rawAutoId?.toString() ?? '') ?? 0;

    final rawShare = json['revenueShare'];
    final parsedShare = rawShare is num
        ? rawShare
        : num.tryParse(rawShare?.toString() ?? '') ?? 0;

    return CompanyProfileModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      autoIncrementId: parsedAutoId,
      longAutoIncrementId: json['longAutoIncrementId']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      legalName: json['legalName']?.toString() ?? '',
      revenueShare: parsedShare,
      status: json['status']?.toString() ?? '',
      email: userMap['email']?.toString() ??
          userIdMap['email']?.toString() ??
          '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  CompanyProfileEntity toEntity() {
    return CompanyProfileEntity(
      id: id,
      autoIncrementId: autoIncrementId,
      longAutoIncrementId: longAutoIncrementId,
      displayName: displayName,
      legalName: legalName,
      revenueShare: revenueShare,
      status: status,
      email: email,
      createdAt: createdAt,
    );
  }
}

class ReferralStatsModel extends ReferralStatsEntity {
  const ReferralStatsModel({
    required super.totalReferredUsers,
    required super.convertedReferredUsers,
    required super.nonconvertedReferredUsers,
  });

  factory ReferralStatsModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

    return ReferralStatsModel(
      totalReferredUsers: parseInt(json['totalReferredUsers']),
      convertedReferredUsers: parseInt(json['convertedReferredUsers']),
      nonconvertedReferredUsers: parseInt(json['nonconvertedReferredUsers']),
    );
  }

  ReferralStatsEntity toEntity() {
    return ReferralStatsEntity(
      totalReferredUsers: totalReferredUsers,
      convertedReferredUsers: convertedReferredUsers,
      nonconvertedReferredUsers: nonconvertedReferredUsers,
    );
  }
}
