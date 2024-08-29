import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Method untuk menyimpan nama lengkap ke SharedPreferences
  static Future<void> saveFullName(String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nama_Lengkap', fullName);
  }

  // Method untuk mengambil nama lengkap dari SharedPreferences
  static Future<String> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nama_Lengkap') ?? 'Wargas';
  }

  // Method untuk menghapus nama lengkap dari SharedPreferences
  static Future<void> deleteFullName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nama_Lengkap');
  }
}
