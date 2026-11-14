import '../../domain/entities/referral_balance_entity.dart';

class CurrencyAmountModel extends CurrencyAmountEntity {
  const CurrencyAmountModel({
    required super.amount,
    required super.currencyCode,
  });

  factory CurrencyAmountModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CurrencyAmountModel(amount: 0.0, currencyCode: 'USD');
    }
    return CurrencyAmountModel(
      amount:
          (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0,
      currencyCode: json['currencyCode']?.toString() ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'currencyCode': currencyCode,
  };

  CurrencyAmountEntity toEntity() => CurrencyAmountEntity(
    amount: amount,
    currencyCode: currencyCode,
  );
}

class ReferralBalanceModel extends ReferralBalanceEntity {
  const ReferralBalanceModel({
    required super.id,
    required super.availableBalance,
    required super.reservedBalance,
    required super.lifetimeEarned,
    required super.lifetimeRedeemed,
    super.createdAt,
    super.updatedAt,
  });

  factory ReferralBalanceModel.fromJson(Map<String, dynamic> json) {
    return ReferralBalanceModel(
      id: json['_id']?.toString() ?? '',
      availableBalance: CurrencyAmountModel.fromJson(
        json['availableBalance'] as Map<String, dynamic>?,
      ).toEntity(),
      reservedBalance: CurrencyAmountModel.fromJson(
        json['reservedBalance'] as Map<String, dynamic>?,
      ).toEntity(),
      lifetimeEarned: CurrencyAmountModel.fromJson(
        json['lifetimeEarned'] as Map<String, dynamic>?,
      ).toEntity(),
      lifetimeRedeemed: CurrencyAmountModel.fromJson(
        json['lifetimeRedeemed'] as Map<String, dynamic>?,
      ).toEntity(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'availableBalance': {
      'amount': availableBalance.amount,
      'currencyCode': availableBalance.currencyCode,
    },
    'reservedBalance': {
      'amount': reservedBalance.amount,
      'currencyCode': reservedBalance.currencyCode,
    },
    'lifetimeEarned': {
      'amount': lifetimeEarned.amount,
      'currencyCode': lifetimeEarned.currencyCode,
    },
    'lifetimeRedeemed': {
      'amount': lifetimeRedeemed.amount,
      'currencyCode': lifetimeRedeemed.currencyCode,
    },
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  ReferralBalanceEntity toEntity() => ReferralBalanceEntity(
    id: id,
    availableBalance: availableBalance,
    reservedBalance: reservedBalance,
    lifetimeEarned: lifetimeEarned,
    lifetimeRedeemed: lifetimeRedeemed,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

