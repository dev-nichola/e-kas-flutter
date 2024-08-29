import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../token_service.dart'; // Pastikan untuk mengimpor TokenService

class LaporanTableService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<List<LaporanKategori>> fetchLaporan() async {
    try {
      final token = await TokenService.getToken();

      if (token == null) {
        throw Exception('Harap login terlebih dahulu.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/laporan'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}'); // Log response body

        List<dynamic> data = json.decode(response.body);
        print('Parsed data: $data'); // Log parsed data

        return data.map((item) => LaporanKategori.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load laporan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching laporan: $e'); // Log error
      throw Exception('Failed to load laporan');
    }
  }
}

class LaporanKategori {
  final String kategoriKas;
  final int totalUangKas;
  final List<DetailLaporan> details;

  LaporanKategori({
    required this.kategoriKas,
    required this.totalUangKas,
    required this.details,
  });

  factory LaporanKategori.fromJson(Map<String, dynamic> json) {
    var list = json['details'] as List;
    List<DetailLaporan> detailList =
        list.map((i) => DetailLaporan.fromJson(i)).toList();

    return LaporanKategori(
      kategoriKas: json['kategoriKas'],
      totalUangKas: json['totalUangKas'],
      details: detailList,
    );
  }
}

class DetailLaporan {
  final String bulan;
  final int pemasukan;
  final int pengeluaran;

  DetailLaporan({
    required this.bulan,
    required this.pemasukan,
    required this.pengeluaran,
  });

  factory DetailLaporan.fromJson(Map<String, dynamic> json) {
    return DetailLaporan(
      bulan: json['bulan'],
      pemasukan: json['pemasukan'],
      pengeluaran: json['pengeluaran'],
    );
  }
}
