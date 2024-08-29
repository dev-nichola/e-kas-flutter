import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../token_service.dart'; // Pastikan untuk mengimpor TokenService

class LaporanService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';


  Future<Map<String, dynamic>> fetchLaporanGrafik() async {
    final url = Uri.parse('$baseUrl/laporan/grafik');
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
        final data = jsonDecode(response.body);
        return {
          'pemasukan': (data['pemasukan'] as List<dynamic>)
              .map((item) => Pemasukan.fromJson(item as Map<String, dynamic>))
              .toList(),
          'pengeluaran': (data['pengeluaran'] as List<dynamic>)
              .map((item) => Pengeluaran.fromJson(item as Map<String, dynamic>))
              .toList(),
          'totalPemasukan': (data['totalPemasukan'] as num).toDouble(),
          'totalPengeluaran': (data['totalPengeluaran'] as num).toDouble(),
          'totalSaldo': (data['totalSaldo'] as num).toDouble(),
        };
      } catch (e) {
        throw Exception('Gagal memproses data: $e');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Token tidak valid atau telah kadaluarsa.');
    } else {
      throw Exception('Gagal mengambil data. Status code: ${response.statusCode}');
    }
  }
}

class Pemasukan {
  final String bulan;
  final double nominal;

  Pemasukan({required this.bulan, required this.nominal});

  factory Pemasukan.fromJson(Map<String, dynamic> json) {
    return Pemasukan(
      bulan: json['bulan'],
      nominal: (json['nominal'] as num).toDouble(),
    );
  }
}

class Pengeluaran {
  final String bulan;
  final double nominal;

  Pengeluaran({required this.bulan, required this.nominal});

  factory Pengeluaran.fromJson(Map<String, dynamic> json) {
    return Pengeluaran(
      bulan: json['bulan'],
      nominal: (json['nominal'] as num).toDouble(),
    );
  }
}
