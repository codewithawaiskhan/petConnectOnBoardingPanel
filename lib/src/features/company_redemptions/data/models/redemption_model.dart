import '../../domain/entities/redemption_entity.dart';

class RedemptionModel extends RedemptionEntity {
  const RedemptionModel({
    required super.id,
    super.autoIncrementId,
    required super.type,
    required super.amount,
    required super.currencyCode,
    required super.accountNumber,
    required super.status,
    super.failedReason,
    super.isMarketingCompany,
    super.marketingCompanyName,
    super.userEmail,
    required super.createdAt,
    super.updatedAt,
  });

  factory RedemptionModel.fromJson(Map<String, dynamic> json) {
    final marketingCompany = json['marketingCompany'] is Map<String, dynamic>
        ? json['marketingCompany'] as Map<String, dynamic>
        : null;

    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : null;

    final userIdObj = user?['userId'] is Map<String, dynamic>
        ? user!['userId'] as Map<String, dynamic>
        : null;

    final email = user?['email']?.toString() ?? userIdObj?['email']?.toString();

    return RedemptionModel(
      id: json['_id']?.toString() ?? '',
      autoIncrementId: json['autoIncrementId'] is num
          ? (json['autoIncrementId'] as num).toInt()
          : null,
      type: json['type']?.toString() ?? 'PayPal',
      amount:
          (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0,
      currencyCode: json['currencyCode']?.toString() ?? 'USD',
      accountNumber: json['accountNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Submitted',
      failedReason: json['failedReason']?.toString(),
      isMarketingCompany: json['isMarketingCompany'] == true,
      marketingCompanyName: marketingCompany?['displayName']?.toString(),
      userEmail: email,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'autoIncrementId': autoIncrementId,
    'type': type,
    'amount': amount,
    'currencyCode': currencyCode,
    'accountNumber': accountNumber,
    'status': status,
    'failedReason': failedReason,
    'isMarketingCompany': isMarketingCompany,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  RedemptionEntity toEntity() => RedemptionEntity(
    id: id,
    autoIncrementId: autoIncrementId,
    type: type,
    amount: amount,
    currencyCode: currencyCode,
    accountNumber: accountNumber,
    status: status,
    failedReason: failedReason,
    isMarketingCompany: isMarketingCompany,
    marketingCompanyName: marketingCompanyName,
    userEmail: userEmail,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

class RedemptionPaginatedModel extends RedemptionPaginatedEntity {
  const RedemptionPaginatedModel({
    required super.docs,
    required super.docsCount,
    required super.pages,
  });

  factory RedemptionPaginatedModel.fromJson(Map<String, dynamic> json) {
    final rawDocs = (json['docs'] as List<dynamic>? ?? []);
    return RedemptionPaginatedModel(
      docs: rawDocs
          .map<RedemptionEntity>(
            (item) =>
                RedemptionModel.fromJson(item as Map<String, dynamic>).toEntity(),
          )
          .toList(),
      docsCount: json['docsCount'] is num
          ? (json['docsCount'] as num).toInt()
          : rawDocs.length,
      pages: json['pages'] is num ? (json['pages'] as num).toInt() : 1,
    );
  }

  RedemptionPaginatedEntity toEntity() => RedemptionPaginatedEntity(
    docs: docs,
    docsCount: docsCount,
    pages: pages,
  );
}

