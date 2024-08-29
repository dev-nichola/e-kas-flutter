import 'dart:convert';
import 'package:e_kas/service/warga/tagihan/models/detail_mode.dart';
import 'package:e_kas/service/warga/tagihan/models/payment_method_model.dart';
import 'package:e_kas/service/warga/tagihan/models/tagihan_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../token_service.dart';

class PaymentMethodService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  // Metode untuk mengambil daftar metode pembayaran
  static Future<List<PaymentMethod>> fetchPaymentMethods() async {
    final url = Uri.parse('$baseUrl/pay/method'); // Ganti dengan endpoint yang sesuai
    final token = await TokenService.getToken();

    // Log URL yang digunakan
    print('Request URL: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Log response body
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Cek apakah data 'success' ada dan bukan null
        if (data['success'] != null && data['success']) {
          final List<dynamic> paymentMethodsJson = data['data'] ?? [];
          return paymentMethodsJson.map((json) => PaymentMethod.fromJson(json)).toList();
        } else {
          final errorMessage = data['message'] ?? 'Unknown error';
          throw Exception('Gagal mengambil metode pembayaran: $errorMessage');
        }
      } else {
        final errorMessage = response.body.isNotEmpty
            ? (json.decode(response.body)['error'] ?? response.reasonPhrase)
            : response.reasonPhrase;
        throw Exception('Gagal mengambil metode pembayaran: $errorMessage');
      }
    } catch (e) {
      rethrow;
    }
  }

 static Future<List<Map<String, dynamic>>> sendPaymentRequest({
  required double totalTagihan,
  required List<Tagihan> selectedTagihan,
  required String paymentMethodCode,
}) async {
  final url = Uri.parse('$baseUrl/pay');
  final token = await TokenService.getToken();

  final body = json.encode({
    'tagihanList': selectedTagihan.map((tagihan) => {
      'idTagihan': tagihan.tagihanId,
      'kategori': tagihan.kategori,
      'bulan': tagihan.bulan,
      'tahun': tagihan.tahun,
      'nominal': tagihan.totalTagihan, // Perbaiki di sini, nominal diambil dari totalTagihan
    }).toList(),
    'paymentCode': paymentMethodCode,
  });

  // Log request body
  print('Request Body: $body');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    // Log response status and body
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      print('Parsed Data: $data'); // Log parsed data

      // Kembalikan data dalam format List<Map<String, dynamic>>
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      final errorMessage = response.body.isNotEmpty
          ? (json.decode(response.body)['error'] ?? response.reasonPhrase)
          : response.reasonPhrase;
      throw Exception('Gagal membuat pembayaran: $errorMessage');
    }
  } catch (e) {
    print('Exception: $e');
    rethrow;
  }
}



}
