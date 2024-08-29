import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'token_service.dart';

class LoginService {
  static String get _baseUrl => dotenv.env['API_URL'] ?? 'http://default-url.com';

  static Future<Map<String, dynamic>?> login(String nik, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nomor_Ktp': nik,
          'password': password,
        }),
      );


      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('token')) {
          final String token = data['token'];

          try {
            final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

            data['role'] = decodedToken['role'] ?? 'Unknown';
            data['nama_Lengkap'] = decodedToken['nama'] ?? 'Unknown';

            // Simpan nama lengkap dalam SharedPreferences
            await TokenService.saveFullName(decodedToken['nama'] ?? 'Unknown');
          } catch (e) {
            data['role'] = 'Unknown';
            data['nama_Lengkap'] = 'Unknown';
          }

          await TokenService.saveToken(token);
          return data;
        } else {
          return {'error': 'No token found in response'};
        }
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        return errorData;
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
