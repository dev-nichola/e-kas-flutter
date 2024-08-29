import 'dart:convert';

import 'package:e_kas/service/bendahara/pengeluaran/pengeluaran_model.dart';
import 'package:e_kas/service/bendahara/pengeluaran/pengeluaranbulanan_model.dart';
import 'package:e_kas/service/bendahara/pengeluaran/pengeluarandetail_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String baseUrl = dotenv.env['API_URL'] ?? '';

Future<String?> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

Future<PengeluaranResponse> getPengeluaranData() async {
  final url = Uri.parse('$baseUrl/laporan/pengeluaran'); // Updated endpoint for pengeluaran
  final token = await getAuthToken();

  if (token == null) {
    throw Exception('Harap login terlebih dahulu.');
  }

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Print the status code and response body
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return PengeluaranResponse.fromJson(jsonData); // Ensure to use the correct model
    } else {
      throw Exception('Gagal memuat data pengeluaran: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e'); // Print the error message
    rethrow; // Rethrow the exception after logging
  }
}

Future<List<Bulanan>> getBulananData(String kategoriKas) async {
  final url = Uri.parse('$baseUrl/laporan/pengeluaran/bulan'); // Endpoint yang diperbarui untuk pengeluaran
  final token = await getAuthToken();

  if (token == null) {
    throw Exception('Harap login terlebih dahulu.');
  }

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'kategoriKas': kategoriKas,
      }),
    );

    // Cetak status kode dan respons body
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      
      // Konversi List<dynamic> ke List<Bulanan>
      return jsonData.map((item) => Bulanan.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data pengeluaran: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e'); // Cetak pesan kesalahan
    rethrow; // Lempar kembali exception setelah mencatat
  }
}

Future<PengeluaranDetail> getDetailData(String kategoriKas, String bulan, int tanggal) async {
  final url = Uri.parse('$baseUrl/laporan/pengeluaran/detail');
  final token = await getAuthToken();

  if (token == null) {
    throw Exception('Harap login terlebih dahulu.');
  }

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'kategoriKas': kategoriKas,
        'bulan': bulan,
        'tanggal': tanggal.toString().padLeft(2, '0'), // Kirim tanggal sebagai string dengan dua digit
      }),
    );

    // Cetak status kode dan respons body
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Parsing response body as a map
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      // Return the parsed data using PengeluaranDetail.fromJson()
      return PengeluaranDetail.fromJson(jsonData);
    } else {
      throw Exception('Gagal memuat data pengeluaran: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error: $e'); // Cetak pesan kesalahan
    rethrow; // Lempar kembali exception setelah mencatat
  }
}
