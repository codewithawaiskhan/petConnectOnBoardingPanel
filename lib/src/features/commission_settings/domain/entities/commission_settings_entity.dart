class PolicyCompanyEntity {
  final String companyId;
  final String displayName;

  const PolicyCompanyEntity({
    required this.companyId,
    required this.displayName,
  });
}

class CompanyCommissionPolicyEntity {
  final String id;
  final int autoIncrementId;
  final PolicyCompanyEntity? company;
  final num commissionRateOnFirstPurchase;
  final num commissionRateOnRenewal;
  final bool isCommissionOnFirstPurchaseEnabled;
  final bool isCommissionOnRenewalEnabled;
  final String effectiveFrom;
  final int version;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  const CompanyCommissionPolicyEntity({
    required this.id,
    required this.autoIncrementId,
    this.company,
    required this.commissionRateOnFirstPurchase,
    required this.commissionRateOnRenewal,
    required this.isCommissionOnFirstPurchaseEnabled,
    required this.isCommissionOnRenewalEnabled,
    required this.effectiveFrom,
    this.version = 1,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
  });
}

class CompanyCommissionPolicyListResponseEntity {
  final bool success;
  final String message;
  final List<CompanyCommissionPolicyEntity> docs;
  final int docsCount;
  final int totalPages;
  final int currentPage;

  const CompanyCommissionPolicyListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
    required this.docsCount,
    required this.totalPages,
    required this.currentPage,
  });
}

class ReferralRewardEntity {
  final num? amount;
  final String? currencyCode;

  const ReferralRewardEntity({
    this.amount,
    this.currencyCode,
  });
}

class RenewalCommissionSettingsEntity {
  final String id;
  final int autoIncrementId;
  final ReferralRewardEntity? referralRewardOnFirstPurchase;
  final ReferralRewardEntity? referralRewardOnRenewal;
  final bool isReferralRewardOnFirstPurchaseEnabled;
  final bool isReferralRewardOnRenewalEnabled;
  final bool isCommissionOnFirstPurchaseEnabled;
  final bool isCommissionOnRenewalEnabled;
  final num commissionRateOnFirstPurchase;
  final num commissionRateOnRenewal;
  final String effectiveFrom;
  final int version;
  final String createdAt;
  final String updatedAt;

  const RenewalCommissionSettingsEntity({
    required this.id,
    required this.autoIncrementId,
    this.referralRewardOnFirstPurchase,
    this.referralRewardOnRenewal,
    required this.isReferralRewardOnFirstPurchaseEnabled,
    required this.isReferralRewardOnRenewalEnabled,
    required this.isCommissionOnFirstPurchaseEnabled,
    required this.isCommissionOnRenewalEnabled,
    required this.commissionRateOnFirstPurchase,
    required this.commissionRateOnRenewal,
    required this.effectiveFrom,
    this.version = 1,
    required this.createdAt,
    required this.updatedAt,
  });
}

class RenewalCommissionSettingsListResponseEntity {
  final bool success;
  final String message;
  final List<RenewalCommissionSettingsEntity> docs;
  final int docsCount;
  final int totalPages;
  final int currentPage;

  const RenewalCommissionSettingsListResponseEntity({
    required this.success,
    required this.message,
    required this.docs,
    required this.docsCount,
    required this.totalPages,
    required this.currentPage,
  });
}

