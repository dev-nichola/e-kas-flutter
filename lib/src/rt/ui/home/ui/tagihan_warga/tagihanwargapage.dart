import 'package:e_kas/service/rt/tagihan/detail/detailmodel.dart';
import 'package:e_kas/service/rt/tagihan/detail/detailservice.dart';
import 'package:e_kas/src/rt/ui/home/ui/tagihan_warga/tagihandetailwargapage.dart';
import 'package:flutter/material.dart';
import 'package:e_kas/service/rt/tagihan/tagihanmodel.dart';
import 'package:e_kas/service/rt/tagihan/tagihanservice.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../../shared/rt/navbar_widget.dart';
import '../../../../../shared/rt/topbar_widget.dart';

class TagihanWargaPage extends StatefulWidget {
  const TagihanWargaPage({super.key});

  @override
  _TagihanWargaPageState createState() => _TagihanWargaPageState();
}

class _TagihanWargaPageState extends State<TagihanWargaPage> {
  int _currentIndex = 5;
  bool _isLoading = true;
  List<TagihanResponse>? _tagihanData;

  @override
  void initState() {
    super.initState();
    _fetchTagihanData();
  }

  Future<void> _fetchTagihanData() async {
    try {
      final data = await getTagihanData();
      setState(() {
        _tagihanData = data;
        _isLoading = false;
      });
      print('Fetched data: $_tagihanData');  // Debugging
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching data: $e');  // Debugging
    }
  }

  void _fetchAndShowDetailTagihan(String userId, int tahun) async {
    try {
      if (userId.isEmpty || tahun <= 0) {
        print('Invalid parameters: userId=$userId, tahun=$tahun');
        return;
      }

      final baseUrl = dotenv.env['API_URL'] ?? '';
      if (baseUrl.isEmpty) {
        throw Exception("Base URL tidak ditemukan. Pastikan telah dikonfigurasi dengan benar.");
      }

      final service = TagihanDetailService(baseUrl);
      final payload = {
        'userId': userId,
        'tahun': tahun.toString(),
      };

      final response = await service.postDetailTagihanWarga(payload);

      if (response != null && response.isNotEmpty) {
        _showResponseDialog(response, userId, tahun);
      } else {
        print('Response is empty');
      }
    } catch (e) {
      print('Error sending detail tagihan data: $e');
    }
  }

  void _showResponseDialog(List<DetailTagihanWargaResponse> response, String userId, int tahun) {
    if (response.isNotEmpty) {
      print('Response: $response');  // Debugging

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TagihanDetailWargaPage(
            userId: userId,
            tahun: tahun,
            data: response,
          ),
        ),
      );
    } else {
      print('Response is empty');
    }
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Topbar(title: 'Tagihan Warga'),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _tagihanData?.length ?? 0,
                      itemBuilder: (context, index) {
                        final tagihan = _tagihanData![index];
                        print('Rendering tagihan data: $tagihan');  // Debugging
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Table(
                            border: TableBorder.all(color: const Color(0xFF06B4B5)),
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(2),
                            },
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                    color: const Color(0xFF06B4B5),
                                    child: Text(
                                      '${tagihan.tahun}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                    color: const Color(0xFF06B4B5),
                                    child: const Text(
                                      '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ...tagihan.data.map((data) {
                                print('Rendering data: $data');  // Debugging
                                return TableRow(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print('Fetching detail tagihan for userId: ${data.userId} and tahun: ${tagihan.tahun}');
                                        _fetchAndShowDetailTagihan(
                                          data.userId,
                                          int.tryParse(tagihan.tahun.toString()) ?? 0,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                        child: Text(data.namaLengkap),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                      child: Text('Rp ${data.nominal}'),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}
