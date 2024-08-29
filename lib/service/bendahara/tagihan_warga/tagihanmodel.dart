class TagihanResponse {
  final String tahun;
  final List<TagihanData> data;

  TagihanResponse({required this.tahun, required this.data});

  factory TagihanResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<TagihanData> dataList =
        list.map((i) => TagihanData.fromJson(i)).toList();

    return TagihanResponse(
      tahun: json['tahun'],
      data: dataList,
    );
  }

  get detailTagihan => null;
}

class TagihanData {
  final String namaLengkap;
  final int nominal;
  final String userId;

  TagihanData({required this.namaLengkap, required this.nominal, required this.userId});

  factory TagihanData.fromJson(Map<String, dynamic> json) {
    return TagihanData(
      namaLengkap: json['nama_Lengkap'],
      nominal: json['nominal'],
      userId: json['userId'],
    );
  }
}
