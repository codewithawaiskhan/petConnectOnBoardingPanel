class RedemptionEntity {
  final String id;
  final int? autoIncrementId;
  final String type; // e.g. "PayPal"
  final double amount;
  final String currencyCode;
  final String accountNumber; // PayPal email
  final String status; // "Submitted", "Paid", "Declined", etc.
  final String? failedReason;
  final bool isMarketingCompany;
  final String? marketingCompanyName;
  final String? userEmail;
  final String createdAt;
  final String? updatedAt;

  const RedemptionEntity({
    required this.id,
    this.autoIncrementId,
    required this.type,
    required this.amount,
    required this.currencyCode,
    required this.accountNumber,
    required this.status,
    this.failedReason,
    this.isMarketingCompany = true,
    this.marketingCompanyName,
    this.userEmail,
    required this.createdAt,
    this.updatedAt,
  });
}

class RedemptionPaginatedEntity {
  final List<RedemptionEntity> docs;
  final int docsCount;
  final int pages;

  const RedemptionPaginatedEntity({
    required this.docs,
    required this.docsCount,
    required this.pages,
  });
}

