import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String baseUrl = dotenv.env['API_URL'] ?? '';

Future<String?> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  // Debug log
  return token;
}

Future<List<dynamic>?> getRiwayatPayment() async {
  final url = Uri.parse('$baseUrl/riwayat/user/{userId}');
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
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      throw Exception('Gagal memproses data: $e');
    }
  } else if (response.statusCode == 401) {
    throw Exception('Token tidak valid atau telah kadaluarsa.');
  } else {
    throw Exception('Gagal mengambil data. Status code: ${response.statusCode}');
  }
}


