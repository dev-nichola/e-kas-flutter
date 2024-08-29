class Status {
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

  Status({
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

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'],
      reference: json['reference'],
      paymentMethod: json['paymentMethod'],
      paymentName: json['paymentName'],
      payCode: json['payCode'],
      checkoutUrl: json['checkoutUrl'],
      expiredTime: DateTime.parse(json['expiredTime']),
      status: json['status'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
