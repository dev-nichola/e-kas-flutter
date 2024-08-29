import 'dart:convert';
import 'package:e_kas/src/bendahara/ui/home/ui/pembayaran/pembayaranwargapage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:e_kas/service/bendahara/tagihan_warga/detail/detailservice.dart';
import 'package:e_kas/service/bendahara/tagihan_warga/detail/detailmodel.dart';
import '../../../../../shared/bendahara/navbar_widget.dart';
import '../../../../../shared/bendahara/topbar_widget.dart';

class TagihanDetailWargaPage extends StatefulWidget {
  const TagihanDetailWargaPage(
      {super.key,
      required this.userId,
      required this.tahun,
      required this.data});

  final String userId;
  final int tahun;
  final List<DetailTagihanWargaResponse> data;

  @override
  _TagihanDetailWargaPageState createState() => _TagihanDetailWargaPageState();
}

class _TagihanDetailWargaPageState extends State<TagihanDetailWargaPage> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<DetailTagihanWargaResponse>? _detailTagihanData;

  @override
  void initState() {
    super.initState();
    _fetchDetailTagihanData();
  }

  Future<void> _fetchDetailTagihanData() async {
    try {
      final baseUrl = dotenv.env['API_URL'] ?? '';

      if (baseUrl.isEmpty) {
        throw Exception(
            "Base URL tidak ditemukan. Pastikan telah dikonfigurasi dengan benar.");
      }

      final service = TagihanDetailService(baseUrl);
      final payload = {
        'userId': widget.userId,
        'tahun': widget.tahun.toString(),
      };

      final response = await service.postDetailTagihanWarga(payload);
      if (response != null && response.isNotEmpty) {
        setState(() {
          _detailTagihanData = response;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Data tidak ditemukan.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error fetching detail tagihan: $e';
      });
      print('Error fetching detail tagihan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Topbar(title: 'Detail Tagihan Warga'),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Pembayaran page with userId and tahun
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
                      side: BorderSide(color: const Color(0xFF06B4B5)),
                    ),
                    child: const Text('Pembayaran'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF06B4B5),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: const Color(0xFF06B4B5)),
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
                    : _hasError
                        ? Center(
                            child: Text(_errorMessage,
                                style: const TextStyle(color: Colors.red)))
                        : ListView.builder(
                            itemCount: _detailTagihanData?.length ?? 0,
                            itemBuilder: (context, index) {
                              final detail = _detailTagihanData![index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16.0),
                                              child: Text(
                                                detail.bulan,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox.shrink(),
                                          ],
                                        ),
                                        TableRow(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 16.0),
                                              child: Text('Nama '),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16.0),
                                              child: Text(detail.namaLengkap),
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
                                                  vertical: 8.0,
                                                  horizontal: 16.0),
                                              child: Text('Nominal Kas'),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 16.0),
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...detail.detailTagihan.map((item) {
                                          return TableRow(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16.0),
                                                child: Text(item.kategoriKas),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16.0),
                                                child: Text(
                                                    'Rp ${item.totalNominal}'),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                        TableRow(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 16.0),
                                              child: Text(
                                                'Total Tagihan',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16.0),
                                              child: Text(
                                                  'Rp ${detail.totalTagihan}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
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
        currentIndex: 0, // Set default index if needed
        onTap: (index) {
          // Handle navbar tap if necessary
        },
      ),
    );
  }
}
