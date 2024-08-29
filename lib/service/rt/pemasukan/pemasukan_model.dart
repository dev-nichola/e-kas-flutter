class KasHariIni {
  final String kategoriKas;
  final int totalNominal;

  KasHariIni({required this.kategoriKas, required this.totalNominal});

  factory KasHariIni.fromJson(Map<String, dynamic> json) {
    return KasHariIni(
      kategoriKas: json['kategoriKas'],
      totalNominal: json['totalNominal'],
    );
  }
}

class Detail {
  final String bulan;
  final int tahun;
  final int totalNominal;

  Detail({required this.bulan, required this.tahun, required this.totalNominal});

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      bulan: json['bulan'],
      tahun: json['tahun'],
      totalNominal: json['totalNominal'],
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
      kategoriKas: json['kategoriKas'],
      totalNominal: json['totalNominal'],
      bersihKas: json['bersihKas'],
      details: (json['details'] as List)
          .map((item) => Detail.fromJson(item))
          .toList(),
    );
  }
}

class PemasukanResponse {
  final List<KasHariIni> kasHariIni;
  final List<Data> data;

  PemasukanResponse({required this.kasHariIni, required this.data});

  factory PemasukanResponse.fromJson(Map<String, dynamic> json) {
    return PemasukanResponse(
      kasHariIni: (json['kasHariIni'] as List)
          .map((item) => KasHariIni.fromJson(item))
          .toList(),
      data: (json['data'] as List).map((item) => Data.fromJson(item)).toList(),
    );
  }
}
