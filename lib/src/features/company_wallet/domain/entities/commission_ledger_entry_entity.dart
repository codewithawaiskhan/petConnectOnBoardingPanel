class CommissionLedgerEntryEntity {
  final String id;
  final int? autoIncrementId;
  final String entryType; // "credit" or "debit"
  final double amount;
  final String currencyCode;
  final bool isRenewal;
  final bool isRefunded;
  final String? sourcePurchaseType; // "INITIAL_PURCHASE", etc.
  final String? productId;
  final double? subscriptionPrice;
  final String? subscriptionCurrency;
  final String? subscriptionType; // "Monthly", "Annual", etc.
  final String? marketingCompanyName;
  final String? userEmail;
  final String? userFullName;
  final String? transactionId;
  final String? originalTransactionId;
  final String createdAt;
  final String? updatedAt;

  const CommissionLedgerEntryEntity({
    required this.id,
    this.autoIncrementId,
    required this.entryType,
    required this.amount,
    required this.currencyCode,
    required this.isRenewal,
    required this.isRefunded,
    this.sourcePurchaseType,
    this.productId,
    this.subscriptionPrice,
    this.subscriptionCurrency,
    this.subscriptionType,
    this.marketingCompanyName,
    this.userEmail,
    this.userFullName,
    this.transactionId,
    this.originalTransactionId,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isCredit => entryType.toLowerCase() == 'credit';
}

class CommissionLedgerPaginatedEntity {
  final List<CommissionLedgerEntryEntity> docs;
  final int docsCount;
  final int pages;

  const CommissionLedgerPaginatedEntity({
    required this.docs,
    required this.docsCount,
    required this.pages,
  });
}

