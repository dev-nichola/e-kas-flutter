class Tagihan {
  final String kategori;
  final double totalTagihan;
  bool statusPembayaran;
  final int tahun;
  final String bulan;
  final String tagihanId;

  Tagihan({
    required this.kategori,
    required this.totalTagihan,
    required this.statusPembayaran,
    required this.tahun,
    required this.bulan,
    required this.tagihanId,
  });

  factory Tagihan.fromJson(Map<String, dynamic> json) {
    return Tagihan(
      kategori: json['kategori'] as String,
      totalTagihan: json['totalTagihan'] is String
          ? double.parse(json['totalTagihan'] as String)
          : (json['totalTagihan'] as num).toDouble(),
      statusPembayaran: json['statusPembayaran'] as bool? ?? false,
      tahun: json['tahun'] is String
          ? int.parse(json['tahun'] as String)
          : json['tahun'] as int,
      bulan: json['bulan'] as String,
      tagihanId: json['tagihanId'] as String,
    );
  }

  get nominal => null;

  Map<String, dynamic> toJson() {
    return {
      'kategori': kategori,
      'totalTagihan': totalTagihan,
      'statusPembayaran': statusPembayaran,
      'tahun': tahun,
      'bulan': bulan,
      'tagihanId': tagihanId,
    };
  }
}
