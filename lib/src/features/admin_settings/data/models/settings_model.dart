import '../../domain/entities/settings_entity.dart';

class MoneyAmountModel extends MoneyAmountEntity {
  const MoneyAmountModel({
    required super.amount,
    required super.currencyCode,
  });

  factory MoneyAmountModel.fromJson(Map<String, dynamic> json) {
    return MoneyAmountModel(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currencyCode: (json['currencyCode'] ?? 'USD').toString(),
    );
  }

  factory MoneyAmountModel.fromEntity(MoneyAmountEntity entity) {
    return MoneyAmountModel(
      amount: entity.amount,
      currencyCode: entity.currencyCode,
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'currencyCode': currencyCode,
  };

  MoneyAmountEntity toEntity() => MoneyAmountEntity(
    amount: amount,
    currencyCode: currencyCode,
  );
}

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    super.id,
    required super.isReferralSystemEnabled,
    required super.payoutThreshold,
    required super.minimumRedeemable,
    super.adminProfit,
    super.platformFee,
    super.vat,
    super.contactEmail,
    super.whatsAppPhone,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      isReferralSystemEnabled: json['isReferralSystemEnabled'] == true,
      payoutThreshold: json['payoutThreshold'] is Map<String, dynamic>
          ? MoneyAmountModel.fromJson(
              json['payoutThreshold'] as Map<String, dynamic>,
            )
          : const MoneyAmountModel(amount: 0.0, currencyCode: 'USD'),
      minimumRedeemable: json['minimumRedeemable'] is Map<String, dynamic>
          ? MoneyAmountModel.fromJson(
              json['minimumRedeemable'] as Map<String, dynamic>,
            )
          : const MoneyAmountModel(amount: 0.0, currencyCode: 'USD'),
      adminProfit: (json['adminProfit'] as num?)?.toDouble(),
      platformFee: (json['platformFee'] as num?)?.toDouble(),
      vat: (json['vat'] as num?)?.toDouble(),
      contactEmail: json['contactEmail']?.toString(),
      whatsAppPhone: json['whatsAppPhone']?.toString(),
    );
  }

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      id: entity.id,
      isReferralSystemEnabled: entity.isReferralSystemEnabled,
      payoutThreshold: entity.payoutThreshold is MoneyAmountModel
          ? entity.payoutThreshold as MoneyAmountModel
          : MoneyAmountModel.fromEntity(entity.payoutThreshold),
      minimumRedeemable: entity.minimumRedeemable is MoneyAmountModel
          ? entity.minimumRedeemable as MoneyAmountModel
          : MoneyAmountModel.fromEntity(entity.minimumRedeemable),
      adminProfit: entity.adminProfit,
      platformFee: entity.platformFee,
      vat: entity.vat,
      contactEmail: entity.contactEmail,
      whatsAppPhone: entity.whatsAppPhone,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'isReferralSystemEnabled': isReferralSystemEnabled,
    'payoutThreshold': (payoutThreshold is MoneyAmountModel
        ? (payoutThreshold as MoneyAmountModel).toJson()
        : MoneyAmountModel.fromEntity(payoutThreshold).toJson()),
    'minimumRedeemable': (minimumRedeemable is MoneyAmountModel
        ? (minimumRedeemable as MoneyAmountModel).toJson()
        : MoneyAmountModel.fromEntity(minimumRedeemable).toJson()),
    if (adminProfit != null) 'adminProfit': adminProfit,
    if (platformFee != null) 'platformFee': platformFee,
    if (vat != null) 'vat': vat,
    if (contactEmail != null) 'contactEmail': contactEmail,
    if (whatsAppPhone != null) 'whatsAppPhone': whatsAppPhone,
  };

  SettingsEntity toEntity() => SettingsEntity(
    id: id,
    isReferralSystemEnabled: isReferralSystemEnabled,
    payoutThreshold: payoutThreshold,
    minimumRedeemable: minimumRedeemable,
    adminProfit: adminProfit,
    platformFee: platformFee,
    vat: vat,
    contactEmail: contactEmail,
    whatsAppPhone: whatsAppPhone,
  );
}
