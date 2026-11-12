import '../../domain/entities/company_dashboard_entity.dart';

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

