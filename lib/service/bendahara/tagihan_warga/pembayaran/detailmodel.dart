class PembayaranDetailModel {
  final String bulan;
  final List<DetailData> data;

  PembayaranDetailModel({
    required this.bulan,
    required this.data,
  });

  factory PembayaranDetailModel.fromJson(Map<String, dynamic> json) {
    return PembayaranDetailModel(
      bulan: json['bulan'] as String,
      data: (json['data'] as List<dynamic>)
          .map((item) => DetailData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bulan': bulan,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class DetailData {
  final String tanggal;
  final String namaLengkap;
  final int totalNominal;
  final List<DetailItem> detail;

  DetailData({
    required this.tanggal,
    required this.namaLengkap,
    required this.totalNominal,
    required this.detail,
  });

  factory DetailData.fromJson(Map<String, dynamic> json) {
    return DetailData(
      tanggal: json['tanggal'] as String,
      namaLengkap: json['nama_Lengkap'] as String,
      totalNominal: json['totalNominal'] as int,
      detail: (json['detail'] as List<dynamic>)
          .map((item) => DetailItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'nama_Lengkap': namaLengkap,
      'totalNominal': totalNominal,
      'detail': detail.map((item) => item.toJson()).toList(),
    };
  }
}

class DetailItem {
  final String kategoriKas;
  final int nominal;
  final String bulanTagihan;

  DetailItem({
    required this.kategoriKas,
    required this.nominal,
    required this.bulanTagihan,
  });

  factory DetailItem.fromJson(Map<String, dynamic> json) {
    return DetailItem(
      kategoriKas: json['kategoriKas'] as String,
      nominal: json['nominal'] as int,
      bulanTagihan: json['bulanTagihan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kategoriKas': kategoriKas,
      'nominal': nominal,
      'bulanTagihan': bulanTagihan,
    };
  }
}
