import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_kas/service/token_service.dart';
import 'package:e_kas/service/bendahara/tagihan/models/tagihan_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LaporanKasService {
  static final String baseUrl = dotenv.env['API_URL'] ?? '';

  static Future<List<Tagihan>> fetchTagihanList() async {
    final url = Uri.parse('$baseUrl/tagihan/list');
    final token = await TokenService.getToken();

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // Log response body
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      // Log type of the top-level data
      print('Top-level JSON Data Type: ${jsonData.runtimeType}');

      final List<Tagihan> tagihanList = [];
      for (var item in jsonData) {
        // Log type of each item in the top-level list
        print('Item Type: ${item.runtimeType}');
        
        var bulanList = item['bulan'] as List<dynamic>;

        // Log type of bulanList
        print('Bulan List Type: ${bulanList.runtimeType}');
        
        for (var bulanItem in bulanList) {
          // Log type of each bulanItem
          print('Bulan Item Type: ${bulanItem.runtimeType}');
          
          var tagihanItems = bulanItem['tagihan'] as List<dynamic>;

          // Log type of tagihanItems
          print('Tagihan Items Type: ${tagihanItems.runtimeType}');
          
          for (var tagihanItem in tagihanItems) {
            // Log type of each tagihanItem
            print('Tagihan Item Type: ${tagihanItem.runtimeType}');
            
            tagihanList.add(Tagihan.fromJson(tagihanItem));
          }
        }
      }

      return tagihanList;
    } else {
      throw Exception('Failed to load tagihan');
    }
  }
}
