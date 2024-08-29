import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahWargaService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> tambahWarga({
    required String namaLengkap,
    required DateTime tanggalLahir,
    required String nomorKtp,
    required String pekerjaan,
    required String alamatLengkap,
    required String jenisKelamin,
    required String agama,
    required String status,
    required String nomorWhatsApp,
    required String role,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/users');
    final token = await getAuthToken();

    if (token == null) {
      print('Error: Auth token is null.');
      throw Exception('Harap login terlebih dahulu.');
    }

    final tanggalLahirString = "${tanggalLahir.toLocal().year}-${tanggalLahir.toLocal().month.toString().padLeft(2, '0')}-${tanggalLahir.toLocal().day.toString().padLeft(2, '0')}";

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nama_Lengkap': namaLengkap,
          'tanggal_Lahir': tanggalLahirString,
          'nomor_Ktp': nomorKtp,
          'pekerjaan': pekerjaan,
          'alamat_Lengkap': alamatLengkap,
          'jenis_kelamin': jenisKelamin,
          'agama': agama,
          'status': status,
          'nomor_whatsapp': nomorWhatsApp,
          'role': role,
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        print('Success: Data berhasil ditambahkan.');
      } else {
        print('Status Code: ${response.statusCode}');
        final errorResponse = jsonDecode(response.body);

        if (errorResponse['error'] != null) {
          final errorCode = errorResponse['error']['code'];
          if (errorCode == 'P2002') {
            // P2002 berarti ada pelanggaran unique constraint
            final target = errorResponse['error']['meta']['target'];
            if (target.contains('nomor_Ktp')) {
              throw Exception('NIK sudah terdaftar.');
            } else if (target.contains('nomor_whatsapp')) {
              throw Exception('Nomor WhatsApp sudah terdaftar.');
            }
          } else {
            throw Exception('Gagal menambahkan warga: ${errorResponse['error']['message'] ?? 'Kesalahan tidak dikenal'}');
          }
        } else {
          throw Exception('Gagal menambahkan warga: ${response.body}');
        }
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('NIK SUDAH TERDAFTAR');
    }
  }
}

class GetWargaService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<dynamic>> getWarga({String query = ''}) async {
    final url = Uri.parse('$baseUrl/users/?page=1&perPage=10${query.isNotEmpty ? '&search=$query' : ''}');
    final token = await getAuthToken();

    if (token == null) {
      print('Error: Auth token is null.');
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Success: Data fetched successfully.');
        return data['users'];
      } else {
        print('Status Code: ${response.statusCode}');
        throw Exception('Failed to fetch warga');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Failed to fetch warga');
    }
  }

  Future<Map<String, dynamic>?> getWargaById(String wargaId) async {
    final url = Uri.parse('$baseUrl/users/$wargaId');
    final token = await getAuthToken();

    if (token == null) {
      print('Error: Auth token is null.');
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Success: Data fetched successfully.');
        return jsonDecode(response.body);
      } else {
        print('Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}

class DeleteWargaService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<bool> deleteWarga(String id) async {
    final url = Uri.parse('$baseUrl/users/$id');
    final token = await getAuthToken();

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Success: Data berhasil dihapus.');
        return true;
      } else {
        print('Status Code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}

class UpdateWargaService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<bool> updateWarga(String id, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/users/$id');
    final token = await getAuthToken();

    if (token == null) {
      print('Error: Auth token is null.');
      return false;
    }

  try {
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(updatedData),
  );

  if (response.statusCode == 200) {
    print('Success: Data berhasil diperbarui.');
    return true;
  } else {
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}'); // Tambahkan baris ini untuk menampilkan body respons
    return false;
  }
} catch (e) {
  print('Exception: $e');
  return false;
}
  }
}

class GetWargaByIdService {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>?> getWargaById(String id) async {
    final url = Uri.parse('$baseUrl/users/$id');
    final token = await getAuthToken();

    if (token == null) {
      print('Error: Auth token is null.');
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Success: Data fetched successfully.');
        return jsonDecode(response.body);
      } else {
        print('Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}

class GetRiwayatWargaById {
  final String baseUrl = dotenv.env['API_URL'] ?? '';

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>?> getRiwayatWargaById(String userId) async {
    final url = Uri.parse('$baseUrl/riwayat/warga/$userId');
    final token = await getAuthToken();

    if (token == null) {
      print('Error: Auth token is null.');
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Success: Data fetched successfully.');
        return jsonDecode(response.body);
      } else {
        print('Status Code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
