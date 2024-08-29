class KasHariIni {
  final String kategoriKas;
  final int totalNominal;

  KasHariIni({
    required this.kategoriKas,
    required this.totalNominal,
  });

  factory KasHariIni.fromJson(Map<String, dynamic> json) {
    return KasHariIni(
      kategoriKas: json['kategoriKas'] ?? '',
      totalNominal: json['totalNominal'] ?? 0,
    );
  }
}

class Detail {
  final String bulan;
  final int tahun;
  final int totalNominal;

  Detail({
    required this.bulan,
    required this.tahun,
    required this.totalNominal,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      bulan: json['bulan'] ?? '',
      tahun: json['tahun'] ?? 0,
      totalNominal: json['totalNominal'] ?? 0,
    );
  }
}

class Data {
  final String kategoriKas;
  final int totalNominal;
  final int bersihKas;
  final List<Detail> details;

  Data({
    required this.kategoriKas,
    required this.totalNominal,
    required this.bersihKas,
    required this.details,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      kategoriKas: json['kategoriKas'] ?? '',
      totalNominal: json['totalNominal'] ?? 0,
      bersihKas: json['bersihKas'] ?? 0,
      details: (json['details'] as List<dynamic>?)
              ?.map((item) => Detail.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
    );
  }

  get bulan => null;

  get tahun => null;
}

class PengeluaranResponse {
  final List<KasHariIni> kasHariIni;
  final List<Data> data;

  PengeluaranResponse({
    required this.kasHariIni,
    required this.data,
  });

  factory PengeluaranResponse.fromJson(Map<String, dynamic> json) {
    return PengeluaranResponse(
      kasHariIni: (json['kasHariIni'] as List<dynamic>?)
              ?.map((item) => KasHariIni.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => Data.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
    );
  }
}


