class PaymentDetail {
  final String idTagihan;
  final String kategori;
  final double nominal;
  final String bulan;
  final int tahun;
  final PaymentDetailInfo detailPembayaran;

  PaymentDetail({
    required this.idTagihan,
    required this.kategori,
    required this.nominal,
    required this.bulan,
    required this.tahun,
    required this.detailPembayaran,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      idTagihan: json['idTagihan'] as String,
      kategori: json['kategori'] as String,
      nominal: (json['nominal'] as num).toDouble(),
      bulan: json['bulan'] as String,
      tahun: json['tahun'] as int,
      detailPembayaran: PaymentDetailInfo.fromJson(json['detailPembayaran'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'idTagihan': idTagihan,
    'kategori': kategori,
    'nominal': nominal,
    'bulan': bulan,
    'tahun': tahun,
    'detailPembayaran': detailPembayaran.toJson(),
  };
}

class PaymentDetailInfo {
  final String id;
  final String reference;
  final String paymentMethod;
  final String paymentName;
  final String payCode;
  final String checkoutUrl;
  final DateTime expiredTime;
  final String status;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentDetailInfo({
    required this.id,
    required this.reference,
    required this.paymentMethod,
    required this.paymentName,
    required this.payCode,
    required this.checkoutUrl,
    required this.expiredTime,
    required this.status,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentDetailInfo.fromJson(Map<String, dynamic> json) {
    return PaymentDetailInfo(
      id: json['id'] as String,
      reference: json['reference'] as String,
      paymentMethod: json['paymentMethod'] as String,
      paymentName: json['paymentName'] as String,
      payCode: json['payCode'] as String,
      checkoutUrl: json['checkoutUrl'] as String,
      expiredTime: DateTime.parse(json['expiredTime'] as String),
      status: json['status'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'reference': reference,
    'paymentMethod': paymentMethod,
    'paymentName': paymentName,
    'payCode': payCode,
    'checkoutUrl': checkoutUrl,
    'expiredTime': expiredTime.toIso8601String(),
    'status': status,
    'userId': userId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
