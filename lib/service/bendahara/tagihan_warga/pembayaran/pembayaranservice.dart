import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'detailmodel.dart';

class PembayaranDetailService {
  final String baseUrl;

  PembayaranDetailService(this.baseUrl);

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<PembayaranDetailModel>> postDetailPembayaranWarga(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/detail/warga/pembayaran'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${await _getAuthToken()}', // Include auth token if required
      },
      body: jsonEncode(payload),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => PembayaranDetailModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load detail Pembayaran warga: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
}
