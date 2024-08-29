import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../token_service.dart';

class Pemasukan {
  final String date;
  final double totalNominal;

  Pemasukan({required this.date, required this.totalNominal});

  factory Pemasukan.fromJson(Map<String, dynamic> json) {
    return Pemasukan(
      date: json['date'] as String? ?? '',
      totalNominal: (json['totalNominal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'totalNominal': totalNominal,
    };
  }
}

class Pengeluaran {
  final String nama;
  final double nominal;

  Pengeluaran({required this.nama, required this.nominal});

  factory Pengeluaran.fromJson(Map<String, dynamic> json) {
    return Pengeluaran(
      nama: json['nama'] as String? ?? '',
      nominal: (json['nominal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nominal': nominal,
    };
  }
}

class Laporan {
  final String kategoriKas;
  final double bersih;
  final double bersihBulanSebelum;

  Laporan({
    required this.kategoriKas,
    required this.bersih,
    required this.bersihBulanSebelum,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      kategoriKas: json['kategoriKas'] as String? ?? '',
      bersih: (json['bersih'] as num?)?.toDouble() ?? 0.0,
      bersihBulanSebelum: (json['bersihBulanSebelum'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kategoriKas': kategoriKas,
      'bersih': bersih,
      'bersihBulanSebelum': bersihBulanSebelum,
    };
  }
}

class Detail {
  final String bulan;
  final double pemasukan;
  final double pengeluaran;

  Detail({
    required this.bulan,
    required this.pemasukan,
    required this.pengeluaran,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      bulan: json['bulan'] as String? ?? '',
      pemasukan: (json['pemasukan'] as num?)?.toDouble() ?? 0.0,
      pengeluaran: (json['pengeluaran'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bulan': bulan,
      'pemasukan': pemasukan,
      'pengeluaran': pengeluaran,
    };
  }
}

class LaporanKasService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  static Future<Map<String, dynamic>> fetchLaporanKas({
    required String bulan,
    required String tahun,
    required String kategoriKas,
  }) async {
    final url = Uri.parse('$baseUrl/laporan/kategori');
    final token = await TokenService.getToken();

    if (token == null) {
      throw Exception('Harap login terlebih dahulu.');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'bulan': bulan,
        'tahun': tahun,
        'kategoriKas': kategoriKas,    
      }),
    );

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        print('Respons JSON data: $data');

        final pemasukanList = (data['pemasukan'] as List<dynamic>)
            .map((item) => Pemasukan.fromJson(item as Map<String, dynamic>))
            .toList();

        final pengeluaranList = (data['pengeluaran'] as List<dynamic>)
            .map((item) => Pengeluaran.fromJson(item as Map<String, dynamic>))
            .toList();

        return {
          'pemasukan': pemasukanList,
          'pengeluaran': pengeluaranList,
          'totalPemasukan': (data['totalPemasukan'] as num?)?.toDouble() ?? 0.0,
          'totalPengeluaran': (data['totalPengeluaran'] as num?)?.toDouble() ?? 0.0,
          'bersih': (data['bersih'] as num?)?.toDouble() ?? 0.0,
          'bersihBulanSebelum': (data['bersihBulanSebelum'] as num?)?.toDouble() ?? 0.0,
        };
      } catch (e) {
        throw Exception('Gagal memproses data: $e');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Token tidak valid atau telah kadaluarsa.');
    } else if (response.statusCode == 403) {
      throw Exception('Akses ditolak: Anda tidak memiliki izin.');
    } else {
      throw Exception('Gagal mengambil data. Status code: ${response.statusCode}');
    }
  }

  static Future<List<Laporan>> getLaporan() async {
    final url = Uri.parse('$baseUrl/laporan');
    final token = await TokenService.getToken();

    if (token == null) {
      throw Exception('Harap login terlebih dahulu.');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data.map((item) => Laporan.fromJson(item as Map<String, dynamic>)).toList();
      } catch (e) {
        throw Exception('Gagal memproses data: $e');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Token tidak valid atau telah kadaluarsa.');
    } else if (response.statusCode == 403) {
      throw Exception('Akses ditolak: Anda tidak memiliki izin.');
    } else {
      throw Exception('Gagal mengambil data. Status code: ${response.statusCode}');
    }
  }
}
