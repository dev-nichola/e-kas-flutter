class DetailItem {
  final String id;
  final String nama;
  final String kategoriKas;
  final int nominal;
  final String tanggalPengeluaran;
  final String? buktiPengeluaran; // Nullable String

  DetailItem({
    required this.id,
    required this.nama,
    required this.kategoriKas,
    required this.nominal,
    required this.tanggalPengeluaran,
    this.buktiPengeluaran, // Nullable String
  });

  factory DetailItem.fromJson(Map<String, dynamic> json) {
    return DetailItem(
      id: json['id'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      kategoriKas: json['kategoriKas'] as String? ?? '',
      nominal: json['nominal'] as int? ?? 0,
      tanggalPengeluaran: json['tanggalPengeluaran'] as String? ?? '',
      buktiPengeluaran: json['buktiPengeluaran'] as String?, // Nullable String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kategoriKas': kategoriKas,
      'nominal': nominal,
      'tanggalPengeluaran': tanggalPengeluaran,
      'buktiPengeluaran': buktiPengeluaran, // Nullable String
    };
  }
}
