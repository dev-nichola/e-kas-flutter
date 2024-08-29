// ignore_for_file: file_names, empty_catches

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

final String baseUrl = dotenv.env['API_URL'] ?? '';

Future<String?> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  return token;
}

Future<List<dynamic>?> getPengeluaranData() async {
  final url = Uri.parse('$baseUrl/pengeluaran');
  final token = await getAuthToken();

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
      return data;
    } catch (e) {
      throw Exception('Gagal memproses data: $e');
    }
  } else if (response.statusCode == 401) {
    throw Exception('Token tidak valid atau telah kadaluarsa.');
  } else if (response.statusCode == 403) {
    throw Exception('Akses ditolak. Periksa izin dan token.');
  } else {
    throw Exception('Gagal mengambil data. Status code: ${response.statusCode}');
  }
}

Future<void> submitPengeluaran(Map<String, dynamic> payload) async {
  final url = Uri.parse('$baseUrl/pengeluaran');
  final request = http.MultipartRequest('POST', url);

  // Mendapatkan token dari SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token != null) {
    request.headers['Authorization'] = 'Bearer $token';
  } else {
  }

  // Menambahkan field
  request.fields['nama'] = payload['nama'];
  request.fields['kategoriKas'] = payload['kategoriKas'] ?? '';
  request.fields['nominal'] = payload['nominal'].toString();
  request.fields['tanggalPengeluaran'] = payload['tanggalPengeluaran'] ?? '';

  // Menambahkan file jika ada
  if (payload['buktiPengeluaran'] != null && payload['buktiPengeluaran'].isNotEmpty) {
    try {
      final file = File(payload['buktiPengeluaran']);
      if (await file.exists()) {
        final multipartFile = await http.MultipartFile.fromPath(
          'buktiPengeluaran',
          file.path,
          contentType: MediaType('image', 'jpeg'), // Ganti sesuai jenis file yang diupload
        );
        request.files.add(multipartFile);
      } else {
      }
    } catch (e) {
    }
  }

  final response = await request.send();

  if (response.statusCode == 201) { // 201 menunjukkan bahwa entitas telah dibuat
    final responseData = await response.stream.bytesToString();
    json.decode(responseData);
  } else {
    throw Exception('Failed to submit pengeluaran');
  }
}


