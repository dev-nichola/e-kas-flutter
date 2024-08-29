class PaymentMethod {
  final String group;
  final String code;
  final String name;
  final String type;
  final Fee feeMerchant;
  final Fee feeCustomer;
  final Fee totalFee;
  final int? minimumFee;
  final int? maximumFee;
  final int minimumAmount;
  final int maximumAmount;
  final String iconUrl;
  final bool active;

  PaymentMethod({
    required this.group,
    required this.code,
    required this.name,
    required this.type,
    required this.feeMerchant,
    required this.feeCustomer,
    required this.totalFee,
    this.minimumFee,
    this.maximumFee,
    required this.minimumAmount,
    required this.maximumAmount,
    required this.iconUrl,
    required this.active,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      group: json['group'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      feeMerchant: Fee.fromJson(json['fee_merchant']),
      feeCustomer: Fee.fromJson(json['fee_customer']),
      totalFee: Fee.fromJson(json['total_fee']),
      minimumFee: json['minimum_fee'] as int?,
      maximumFee: json['maximum_fee'] as int?,
      minimumAmount: json['minimum_amount'] as int,
      maximumAmount: json['maximum_amount'] as int,
      iconUrl: json['icon_url'] as String,
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'group': group,
    'code': code,
    'name': name,
    'type': type,
    'fee_merchant': feeMerchant.toJson(),
    'fee_customer': feeCustomer.toJson(),
    'total_fee': totalFee.toJson(),
    'minimum_fee': minimumFee,
    'maximum_fee': maximumFee,
    'minimum_amount': minimumAmount,
    'maximum_amount': maximumAmount,
    'icon_url': iconUrl,
    'active': active,
  };
}

class Fee {
  final int flat;
  final dynamic percent; // Gunakan dynamic jika jenis nilai bervariasi

  Fee({
    required this.flat,
    required this.percent,
  });

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      flat: json['flat'] as int,
      percent: json['percent'], // Bisa int atau string
    );
  }

  Map<String, dynamic> toJson() => {
    'flat': flat,
    'percent': percent,
  };
}
