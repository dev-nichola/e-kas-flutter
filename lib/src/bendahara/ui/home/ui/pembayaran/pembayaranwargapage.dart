
import 'package:e_kas/service/bendahara/tagihan_warga/detail/detailmodel.dart';
import 'package:e_kas/service/bendahara/tagihan_warga/detail/detailservice.dart';
import 'package:e_kas/service/bendahara/tagihan_warga/pembayaran/detailmodel.dart';
import 'package:e_kas/service/bendahara/tagihan_warga/pembayaran/pembayaranservice.dart';
import 'package:e_kas/src/bendahara/ui/home/ui/tagihan_warga/tagihandetailwargapage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../shared/bendahara/navbar_widget.dart';
import '../../../../../shared/bendahara/topbar_widget.dart';




class PembayaranWargaPage extends StatefulWidget {
  final String userId;
  final int tahun;

  const PembayaranWargaPage({
    Key? key,
    required this.userId,
    required this.tahun,
  }) : super(key: key);

  @override
  _PembayaranWargaPageState createState() => _PembayaranWargaPageState();
}

class _PembayaranWargaPageState extends State<PembayaranWargaPage> {
  int _currentIndex = 5;
  bool _isLoading = true;
  List<PembayaranDetailModel>? _tagihanData;

  @override
  void initState() {
    super.initState();
    _fetchTagihanData();
  }

  Future<void> _fetchTagihanData() async {
    try {
      final service = PembayaranDetailService(dotenv.env['API_URL'] ?? '');
      final payload = {
        'userId': widget.userId,
        'tahun': widget.tahun.toString(),
      };
      final data = await service.postDetailPembayaranWarga(payload);
      setState(() {
        _tagihanData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Optionally show an error message to the user
      print('Error fetching tagihan data: $e');
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
            const Topbar(title: 'Pembayaran Warga'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PembayaranWargaPage(
                            userId: widget.userId,
                            tahun: widget.tahun,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF06B4B5),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF06B4B5)),
                    ),
                    child: const Text('Pembayaran'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _fetchAndShowDetailTagihan(widget.userId, widget.tahun);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF06B4B5),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF06B4B5)),
                    ),
                    child: const Text('Tagihan'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _tagihanData?.length ?? 0,
                        itemBuilder: (context, index) {
                          final tagihan = _tagihanData![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Table(
                                      border: const TableBorder(
                                        horizontalInside: BorderSide.none,
                                        verticalInside: BorderSide.none,
                                      ),
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(2),
                                      },
                                      children: [
                                        TableRow(
                                          decoration: const BoxDecoration(
                                              color: Color(0xFF06B4B5)),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 8.0, horizontal: 16.0),
                                              child: Text(
                                                '${tagihan.bulan} ${widget.tahun}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox.shrink(),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0, horizontal: 16.0),
                                              child: Text('Nama'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 8.0, horizontal: 16.0),
                                              child: Text(
                                                tagihan.data.map((data) => data.namaLengkap).join(', '),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0, horizontal: 16.0),
                                              child: Text('Tanggal'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 8.0, horizontal: 16.0),
                                              child: Text(
                                                tagihan.data.map((data) => data.tanggal).join(', '),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Table(
                                      border: const TableBorder(
                                        horizontalInside: BorderSide.none,
                                        verticalInside: BorderSide.none,
                                      ),
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(2),
                                      },
                                      children: [
                                        const TableRow(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0, horizontal: 16.0),
                                              child: Text('Nominal Kas'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0, horizontal: 16.0),
                                              child: Text(''),
                                            ),
                                          ],
                                        ),
                                        ...tagihan.data.expand((data) => data.detail).map((item) {
                                          return TableRow(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 8.0, horizontal: 16.0),
                                                child: Text(item.kategoriKas),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 8.0, horizontal: 16.0),
                                                child: Text(
                                                    'Rp ${item.nominal}',
                                                    style: const TextStyle(
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                        TableRow(
                                          decoration: const BoxDecoration(),
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0, horizontal: 16.0),
                                              child: Text(
                                                'Total',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 8.0, horizontal: 16.0),
                                              child: Text(
                                                  'Rp ${tagihan.data.expand((data) => data.detail).map((item) => item.nominal).reduce((a, b) => a + b)}',
                                                  style: const TextStyle(
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
