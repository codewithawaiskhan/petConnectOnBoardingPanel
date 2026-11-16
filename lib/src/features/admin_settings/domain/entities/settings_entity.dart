class MoneyAmountEntity {
  final double amount;
  final String currencyCode;

  const MoneyAmountEntity({
    required this.amount,
    required this.currencyCode,
  });
}

class SettingsEntity {
  final String? id;
  final bool isReferralSystemEnabled;
  final MoneyAmountEntity payoutThreshold;
  final MoneyAmountEntity minimumRedeemable;
  final double? adminProfit;
  final double? platformFee;
  final double? vat;
  final String? contactEmail;
  final String? whatsAppPhone;

  const SettingsEntity({
    this.id,
    required this.isReferralSystemEnabled,
    required this.payoutThreshold,
    required this.minimumRedeemable,
    this.adminProfit,
    this.platformFee,
    this.vat,
    this.contactEmail,
    this.whatsAppPhone,
  });
}
