// class DetailTagihanWargaResponse
class DetailTagihanWargaResponse {
  final String namaLengkap;
  final String bulan;
  final int totalTagihan;
  final List<DetailTagihan> detailTagihan;

  DetailTagihanWargaResponse({
    required this.namaLengkap,
    required this.bulan,
    required this.totalTagihan,
    required this.detailTagihan,
  });

  factory DetailTagihanWargaResponse.fromJson(Map<String, dynamic> json) {
    var list = json['detailTagihan'] as List;
    List<DetailTagihan> detailTagihanList = list.map((i) => DetailTagihan.fromJson(i)).toList();

    return DetailTagihanWargaResponse(
      namaLengkap: json['nama_Lengkap'],
      bulan: json['bulan'],
      totalTagihan: json['totalTagihan'],
      detailTagihan: detailTagihanList,
    );
  }

  get userId => null;
}

// class DetailTagihan
class DetailTagihan {
  final String kategoriKas; // Updated to camelCase
  final int totalNominal;

  DetailTagihan({
    required this.kategoriKas,
    required this.totalNominal,
  });

  factory DetailTagihan.fromJson(Map<String, dynamic> json) {
    return DetailTagihan(
      kategoriKas: json['KategoriKas'],
      totalNominal: json['totalNominal'],
    );
  }

  get nominalKas => null;
}
