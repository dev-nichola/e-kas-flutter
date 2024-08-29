class PemasukanDetail {
  final String date;
  final List<User> user; // Change 'details' to 'user'
  final int totalNominal;

  PemasukanDetail({
    required this.date,
    required this.user, // Change 'details' to 'user'
    required this.totalNominal,
  });

  factory PemasukanDetail.fromJson(Map<String, dynamic> json) {
    return PemasukanDetail(
      date: json['date'],
      user: (json['user'] as List)
          .map((detail) => User.fromJson(detail))
          .toList(),
      totalNominal: json['totalNominal'],
    );
  }

  get details => null;
}

class User {
  final String namaLengkap; // Match with the JSON field 'nama_lengkap'
  final int nominal;

  User({
    required this.namaLengkap, // Match with the JSON field 'nama_lengkap'
    required this.nominal,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      namaLengkap: json['nama_lengkap'], // Match with the JSON field 'nama_lengkap'
      nominal: json['nominal'],
    );
  }
}
