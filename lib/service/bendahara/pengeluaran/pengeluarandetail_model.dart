class PengeluaranDetail {
  final String date;
  final int totalNominal;
  final List<DetailItem> details;

  PengeluaranDetail({
    required this.date,
    required this.totalNominal,
    required this.details,
  });

  factory PengeluaranDetail.fromJson(Map<String, dynamic> json) {
    return PengeluaranDetail(
      date: json['date'] as String,
      totalNominal: json['totalNominal'] as int,
      details: (json['details'] as List<dynamic>)
          .map((item) => DetailItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DetailItem {
  final String id;
  final String nama;
  final String kategoriKas;
  final int nominal;
  final String tanggalPengeluaran;
  final String buktiPengeluaran;

  DetailItem({
    required this.id,
    required this.nama,
    required this.kategoriKas,
    required this.nominal,
    required this.tanggalPengeluaran,
    required this.buktiPengeluaran,
  });

  factory DetailItem.fromJson(Map<String, dynamic> json) {
    return DetailItem(
      id: json['id'] as String,
      nama: json['nama'] as String,
      kategoriKas: json['kategoriKas'] as String,
      nominal: json['nominal'] as int,
      tanggalPengeluaran: json['tanggalPengeluaran'] as String,
      buktiPengeluaran: json['buktiPengeluaran'] as String,
    );
  }
}
