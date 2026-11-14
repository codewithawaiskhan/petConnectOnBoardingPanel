class CurrencyAmountEntity {
  final double amount;
  final String currencyCode;

  const CurrencyAmountEntity({
    required this.amount,
    required this.currencyCode,
  });
}

class ReferralBalanceEntity {
  final String id;
  final CurrencyAmountEntity availableBalance;
  final CurrencyAmountEntity reservedBalance;
  final CurrencyAmountEntity lifetimeEarned;
  final CurrencyAmountEntity lifetimeRedeemed;
  final String? createdAt;
  final String? updatedAt;

  const ReferralBalanceEntity({
    required this.id,
    required this.availableBalance,
    required this.reservedBalance,
    required this.lifetimeEarned,
    required this.lifetimeRedeemed,
    this.createdAt,
    this.updatedAt,
  });
}

