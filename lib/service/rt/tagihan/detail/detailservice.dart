import 'dart:convert';
import 'package:e_kas/service/rt/tagihan/detail/detailmodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TagihanDetailService {
  final String baseUrl;

  TagihanDetailService(this.baseUrl);

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<DetailTagihanWargaResponse>> postDetailTagihanWarga(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/detail/warga/tagihan'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await _getAuthToken()}', // Jika diperlukan
      },
      body: jsonEncode(payload),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => DetailTagihanWargaResponse.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load detail tagihan warga: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
