import 'dart:convert';
import 'package:e_kas/service/bendahara/tagihan/models/cekstatus_model.dart';
import 'package:http/http.dart' as http;
import 'package:e_kas/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StatusService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  static Future<Status?> fetchStatus(String detailPembayaranId) async {
    final url = Uri.parse('$baseUrl/pay/status/$detailPembayaranId');
    final token = await TokenService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return Status.fromJson(json);
    } else {
      throw Exception('Failed to load status');
    }
  }
}
