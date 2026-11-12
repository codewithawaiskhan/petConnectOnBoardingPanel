import '../../domain/entities/commission_settings_entity.dart';

class ReferralRewardModel extends ReferralRewardEntity {
  const ReferralRewardModel({
    super.amount,
    super.currencyCode,
  });

  factory ReferralRewardModel.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'];
    final parsedAmount = rawAmount is num
        ? rawAmount
        : (rawAmount != null ? num.tryParse(rawAmount.toString()) : null);

    return ReferralRewardModel(
      amount: parsedAmount,
      currencyCode: json['currencyCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currencyCode': currencyCode,
    };
  }

  ReferralRewardEntity toEntity() {
    return ReferralRewardEntity(
      amount: amount,
      currencyCode: currencyCode,
    );
  }
}

class RenewalCommissionSettingsModel extends RenewalCommissionSettingsEntity {
  const RenewalCommissionSettingsModel({
    required super.id,
    required super.autoIncrementId,
    super.referralRewardOnFirstPurchase,
    super.referralRewardOnRenewal,
    required super.isReferralRewardOnFirstPurchaseEnabled,
    required super.isReferralRewardOnRenewalEnabled,
    required super.isCommissionOnFirstPurchaseEnabled,
    required super.isCommissionOnRenewalEnabled,
    required super.commissionRateOnFirstPurchase,
    required super.commissionRateOnRenewal,
    required super.effectiveFrom,
    super.version = 1,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RenewalCommissionSettingsModel.fromJson(Map<String, dynamic> json) {
    final rawAutoId = json['autoIncrementId'];
    final parsedAutoId = rawAutoId is int
        ? rawAutoId
        : int.tryParse(rawAutoId?.toString() ?? '') ?? 0;

    final rawFirstRate = json['commissionRateOnFirstPurchase'];
    final parsedFirstRate = rawFirstRate is num
        ? rawFirstRate
        : num.tryParse(rawFirstRate?.toString() ?? '') ?? 0;

    final rawRenewalRate = json['commissionRateOnRenewal'];
    final parsedRenewalRate = rawRenewalRate is num
        ? rawRenewalRate
        : num.tryParse(rawRenewalRate?.toString() ?? '') ?? 0;

    final rawVersion = json['version'];
    final parsedVersion = rawVersion is int
        ? rawVersion
        : int.tryParse(rawVersion?.toString() ?? '') ?? 1;

    return RenewalCommissionSettingsModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      autoIncrementId: parsedAutoId,
      referralRewardOnFirstPurchase:
          json['referralRewardOnFirstPurchase'] is Map<String, dynamic>
              ? ReferralRewardModel.fromJson(
                  json['referralRewardOnFirstPurchase'] as Map<String, dynamic>,
                ).toEntity()
              : null,
      referralRewardOnRenewal:
          json['referralRewardOnRenewal'] is Map<String, dynamic>
              ? ReferralRewardModel.fromJson(
                  json['referralRewardOnRenewal'] as Map<String, dynamic>,
                ).toEntity()
              : null,
      isReferralRewardOnFirstPurchaseEnabled:
          json['isReferralRewardOnFirstPurchaseEnabled'] == true,
      isReferralRewardOnRenewalEnabled:
          json['isReferralRewardOnRenewalEnabled'] == true,
      isCommissionOnFirstPurchaseEnabled:
          json['isCommissionOnFirstPurchaseEnabled'] == true,
      isCommissionOnRenewalEnabled:
          json['isCommissionOnRenewalEnabled'] == true,
      commissionRateOnFirstPurchase: parsedFirstRate,
      commissionRateOnRenewal: parsedRenewalRate,
      effectiveFrom: json['effectiveFrom']?.toString() ?? '',
      version: parsedVersion,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'autoIncrementId': autoIncrementId,
      'referralRewardOnFirstPurchase': referralRewardOnFirstPurchase != null
          ? {
              'amount': referralRewardOnFirstPurchase!.amount,
              'currencyCode': referralRewardOnFirstPurchase!.currencyCode,
            }
          : null,
      'referralRewardOnRenewal': referralRewardOnRenewal != null
          ? {
              'amount': referralRewardOnRenewal!.amount,
              'currencyCode': referralRewardOnRenewal!.currencyCode,
            }
          : null,
      'isReferralRewardOnFirstPurchaseEnabled':
          isReferralRewardOnFirstPurchaseEnabled,
      'isReferralRewardOnRenewalEnabled': isReferralRewardOnRenewalEnabled,
      'isCommissionOnFirstPurchaseEnabled': isCommissionOnFirstPurchaseEnabled,
      'isCommissionOnRenewalEnabled': isCommissionOnRenewalEnabled,
      'commissionRateOnFirstPurchase': commissionRateOnFirstPurchase,
      'commissionRateOnRenewal': commissionRateOnRenewal,
      'effectiveFrom': effectiveFrom,
      'version': version,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  RenewalCommissionSettingsEntity toEntity() {
    return RenewalCommissionSettingsEntity(
      id: id,
      autoIncrementId: autoIncrementId,
      referralRewardOnFirstPurchase: referralRewardOnFirstPurchase,
      referralRewardOnRenewal: referralRewardOnRenewal,
      isReferralRewardOnFirstPurchaseEnabled:
          isReferralRewardOnFirstPurchaseEnabled,
      isReferralRewardOnRenewalEnabled: isReferralRewardOnRenewalEnabled,
      isCommissionOnFirstPurchaseEnabled: isCommissionOnFirstPurchaseEnabled,
      isCommissionOnRenewalEnabled: isCommissionOnRenewalEnabled,
      commissionRateOnFirstPurchase: commissionRateOnFirstPurchase,
      commissionRateOnRenewal: commissionRateOnRenewal,
      effectiveFrom: effectiveFrom,
      version: version,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class RenewalCommissionSettingsListResponseModel
    extends RenewalCommissionSettingsListResponseEntity {
  const RenewalCommissionSettingsListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
    required super.docsCount,
    required super.totalPages,
    required super.currentPage,
  });

  factory RenewalCommissionSettingsListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final rawDocs = data['docs'] as List<dynamic>? ?? <dynamic>[];

    final List<RenewalCommissionSettingsEntity> parsedDocs = rawDocs
        .whereType<Map<String, dynamic>>()
        .map<RenewalCommissionSettingsEntity>(
          (e) => RenewalCommissionSettingsModel.fromJson(e).toEntity(),
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

    return RenewalCommissionSettingsListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
      docsCount: parsedDocsCount,
      totalPages: parsedPages > 0 ? parsedPages : 1,
      currentPage: parsedPage > 0 ? parsedPage : 1,
    );
  }

  RenewalCommissionSettingsListResponseEntity toEntity() {
    return RenewalCommissionSettingsListResponseEntity(
      success: success,
      message: message,
      docs: List<RenewalCommissionSettingsEntity>.from(docs),
      docsCount: docsCount,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

