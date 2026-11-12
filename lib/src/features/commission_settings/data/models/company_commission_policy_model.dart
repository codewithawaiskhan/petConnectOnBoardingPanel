import '../../domain/entities/commission_settings_entity.dart';

class PolicyCompanyModel extends PolicyCompanyEntity {
  const PolicyCompanyModel({
    required super.companyId,
    required super.displayName,
  });

  factory PolicyCompanyModel.fromJson(Map<String, dynamic> json) {
    return PolicyCompanyModel(
      companyId: json['companyId']?.toString() ?? json['_id']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'displayName': displayName,
    };
  }

  PolicyCompanyEntity toEntity() {
    return PolicyCompanyEntity(
      companyId: companyId,
      displayName: displayName,
    );
  }
}

class CompanyCommissionPolicyModel extends CompanyCommissionPolicyEntity {
  const CompanyCommissionPolicyModel({
    required super.id,
    required super.autoIncrementId,
    super.company,
    required super.commissionRateOnFirstPurchase,
    required super.commissionRateOnRenewal,
    required super.isCommissionOnFirstPurchaseEnabled,
    required super.isCommissionOnRenewalEnabled,
    required super.effectiveFrom,
    super.version = 1,
    super.isDeleted = false,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CompanyCommissionPolicyModel.fromJson(Map<String, dynamic> json) {
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

    return CompanyCommissionPolicyModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      autoIncrementId: parsedAutoId,
      company: json['company'] is Map<String, dynamic>
          ? PolicyCompanyModel.fromJson(
              json['company'] as Map<String, dynamic>,
            ).toEntity()
          : null,
      commissionRateOnFirstPurchase: parsedFirstRate,
      commissionRateOnRenewal: parsedRenewalRate,
      isCommissionOnFirstPurchaseEnabled:
          json['isCommissionOnFirstPurchaseEnabled'] == true,
      isCommissionOnRenewalEnabled:
          json['isCommissionOnRenewalEnabled'] == true,
      effectiveFrom: json['effectiveFrom']?.toString() ?? '',
      version: parsedVersion,
      isDeleted: json['isDeleted'] == true,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'autoIncrementId': autoIncrementId,
      if (company != null)
        'company': {
          'companyId': company!.companyId,
          'displayName': company!.displayName,
        },
      'commissionRateOnFirstPurchase': commissionRateOnFirstPurchase,
      'commissionRateOnRenewal': commissionRateOnRenewal,
      'isCommissionOnFirstPurchaseEnabled': isCommissionOnFirstPurchaseEnabled,
      'isCommissionOnRenewalEnabled': isCommissionOnRenewalEnabled,
      'effectiveFrom': effectiveFrom,
      'version': version,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  CompanyCommissionPolicyEntity toEntity() {
    return CompanyCommissionPolicyEntity(
      id: id,
      autoIncrementId: autoIncrementId,
      company: company,
      commissionRateOnFirstPurchase: commissionRateOnFirstPurchase,
      commissionRateOnRenewal: commissionRateOnRenewal,
      isCommissionOnFirstPurchaseEnabled: isCommissionOnFirstPurchaseEnabled,
      isCommissionOnRenewalEnabled: isCommissionOnRenewalEnabled,
      effectiveFrom: effectiveFrom,
      version: version,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class CompanyCommissionPolicyListResponseModel
    extends CompanyCommissionPolicyListResponseEntity {
  const CompanyCommissionPolicyListResponseModel({
    required super.success,
    required super.message,
    required super.docs,
    required super.docsCount,
    required super.totalPages,
    required super.currentPage,
  });

  factory CompanyCommissionPolicyListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    final rawDocs = data['docs'] as List<dynamic>? ?? <dynamic>[];

    final List<CompanyCommissionPolicyEntity> parsedDocs = rawDocs
        .whereType<Map<String, dynamic>>()
        .map<CompanyCommissionPolicyEntity>(
          (e) => CompanyCommissionPolicyModel.fromJson(e).toEntity(),
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

    return CompanyCommissionPolicyListResponseModel(
      success: json['success'] == true || json['status'] == 'success',
      message: data['message']?.toString() ?? json['message']?.toString() ?? '',
      docs: parsedDocs,
      docsCount: parsedDocsCount,
      totalPages: parsedPages > 0 ? parsedPages : 1,
      currentPage: parsedPage > 0 ? parsedPage : 1,
    );
  }

  CompanyCommissionPolicyListResponseEntity toEntity() {
    return CompanyCommissionPolicyListResponseEntity(
      success: success,
      message: message,
      docs: List<CompanyCommissionPolicyEntity>.from(docs),
      docsCount: docsCount,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

