import 'dart:convert';
import 'package:e_kas/service/bendahara/tagihan_warga/tagihanmodel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String baseUrl = dotenv.env['API_URL'] ?? '';

Future<String?> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  return token;
}

Future<List<TagihanResponse>?> getTagihanData() async {
  final url = Uri.parse('$baseUrl/detail/warga/tagihan');
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
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item) => TagihanResponse.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error parsing data: $e');
    }
  } else {
    throw Exception('Gagal memuat data tagihan: ${response.reasonPhrase}');
  }
}
