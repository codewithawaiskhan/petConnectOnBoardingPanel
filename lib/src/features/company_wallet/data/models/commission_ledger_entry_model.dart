import '../../domain/entities/commission_ledger_entry_entity.dart';

class CommissionLedgerEntryModel extends CommissionLedgerEntryEntity {
  const CommissionLedgerEntryModel({
    required super.id,
    super.autoIncrementId,
    required super.entryType,
    required super.amount,
    required super.currencyCode,
    required super.isRenewal,
    required super.isRefunded,
    super.sourcePurchaseType,
    super.productId,
    super.subscriptionPrice,
    super.subscriptionCurrency,
    super.subscriptionType,
    super.marketingCompanyName,
    super.userEmail,
    super.userFullName,
    super.transactionId,
    super.originalTransactionId,
    required super.createdAt,
    super.updatedAt,
  });

  factory CommissionLedgerEntryModel.fromJson(Map<String, dynamic> json) {
    final sourcePurchase = json['sourcePurchaseId'] is Map<String, dynamic>
        ? json['sourcePurchaseId'] as Map<String, dynamic>
        : null;

    final userSub = json['userSubscription'] is Map<String, dynamic>
        ? json['userSubscription'] as Map<String, dynamic>
        : null;

    final marketingCompany = json['marketingCompany'] is Map<String, dynamic>
        ? json['marketingCompany'] as Map<String, dynamic>
        : null;

    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : null;

    final userIdObj = user?['userId'] is Map<String, dynamic>
        ? user!['userId'] as Map<String, dynamic>
        : null;

    final num? rawSubPrice = userSub?['price'] as num?;

    return CommissionLedgerEntryModel(
      id: json['_id']?.toString() ?? '',
      autoIncrementId: json['autoIncrementId'] is num
          ? (json['autoIncrementId'] as num).toInt()
          : null,
      entryType: json['entryType']?.toString() ?? 'credit',
      amount:
          (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0,
      currencyCode: json['currencyCode']?.toString() ?? 'USD',
      isRenewal: json['isRenewal'] == true,
      isRefunded: json['isRefunded'] == true,
      sourcePurchaseType: sourcePurchase?['type']?.toString(),
      productId: sourcePurchase?['productId']?.toString(),
      subscriptionPrice: rawSubPrice?.toDouble(),
      subscriptionCurrency: userSub?['currencyCode']?.toString(),
      subscriptionType: userSub?['type']?.toString(),
      marketingCompanyName: marketingCompany?['displayName']?.toString(),
      userEmail: user?['email']?.toString() ?? userIdObj?['email']?.toString(),
      userFullName: userIdObj?['fullName']?.toString(),
      transactionId: json['transactionId']?.toString(),
      originalTransactionId: json['originalTransactionId']?.toString(),
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'autoIncrementId': autoIncrementId,
    'entryType': entryType,
    'amount': amount,
    'currencyCode': currencyCode,
    'isRenewal': isRenewal,
    'isRefunded': isRefunded,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  CommissionLedgerEntryEntity toEntity() => CommissionLedgerEntryEntity(
    id: id,
    autoIncrementId: autoIncrementId,
    entryType: entryType,
    amount: amount,
    currencyCode: currencyCode,
    isRenewal: isRenewal,
    isRefunded: isRefunded,
    sourcePurchaseType: sourcePurchaseType,
    productId: productId,
    subscriptionPrice: subscriptionPrice,
    subscriptionCurrency: subscriptionCurrency,
    subscriptionType: subscriptionType,
    marketingCompanyName: marketingCompanyName,
    userEmail: userEmail,
    userFullName: userFullName,
    transactionId: transactionId,
    originalTransactionId: originalTransactionId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

class CommissionLedgerPaginatedModel extends CommissionLedgerPaginatedEntity {
  const CommissionLedgerPaginatedModel({
    required super.docs,
    required super.docsCount,
    required super.pages,
  });

  factory CommissionLedgerPaginatedModel.fromJson(Map<String, dynamic> json) {
    final rawDocs = (json['docs'] as List<dynamic>? ?? []);
    return CommissionLedgerPaginatedModel(
      docs: rawDocs
          .map<CommissionLedgerEntryEntity>(
            (item) => CommissionLedgerEntryModel.fromJson(
              item as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList(),
      docsCount: json['docsCount'] is num
          ? (json['docsCount'] as num).toInt()
          : rawDocs.length,
      pages: json['pages'] is num ? (json['pages'] as num).toInt() : 1,
    );
  }

  CommissionLedgerPaginatedEntity toEntity() => CommissionLedgerPaginatedEntity(
    docs: docs,
    docsCount: docsCount,
    pages: pages,
  );
}

