class Detail {
  final String date;
  final int totalNominal;

  Detail({
    required this.date,
    required this.totalNominal,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      date: json['date'] ?? '',
      totalNominal: json['totalNominal'] ?? 0,
    );
  }
}

class Bulanan {
  final String bulan;
  final String tahun;
  final String kategoriKas;
  final int totalNominal;
  final List<Detail> detail;

  Bulanan({
    required this.bulan,
    required this.tahun,
    required this.kategoriKas,
    required this.totalNominal,
    required this.detail,
  });

  factory Bulanan.fromJson(Map<String, dynamic> json) {
    return Bulanan(
      bulan: json['bulan'] ?? '',
      tahun: json['tahun'] ?? '',
      kategoriKas: json['kategoriKas'] ?? '',
      totalNominal: json['totalNominal'] ?? 0,
      detail: (json['detail'] as List<dynamic>?)
              ?.map((item) => Detail.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
    );
  }
}
