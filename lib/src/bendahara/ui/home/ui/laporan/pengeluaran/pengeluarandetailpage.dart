import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:e_kas/service/bendahara/pengeluaran/pengeluaran_service.dart';
import 'package:e_kas/service/bendahara/pengeluaran/pengeluarandetail_model.dart';

import '../../../../../../shared/bendahara/navbar_widget.dart';
import '../../../../../../shared/bendahara/topbar_widget.dart';

class PengeluaranDetailPage extends StatefulWidget {
  final String kategoriKas;
  final String bulan;
  final int tanggal;

  const PengeluaranDetailPage({
    required this.kategoriKas,
    required this.bulan,
    required this.tanggal,
    Key? key,
    required PengeluaranDetail detail,
  }) : super(key: key);

  @override
  State<PengeluaranDetailPage> createState() => _PengeluaranDetailPageState();
}

class _PengeluaranDetailPageState extends State<PengeluaranDetailPage> {
  bool _isLoading = true;
  PengeluaranDetail? _response;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPengeluaranData();
  }

  Future<void> _fetchPengeluaranData() async {
    try {
      final response = await getDetailData(widget.kategoriKas, widget.bulan, widget.tanggal);

      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching pengeluaran data: $e');

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data Pengeluaran: $e')),
      );
    }
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.network(imageUrl),
        );
      },
    );
  }

  Widget _buildImage(String imagePath) {
    final String baseUrl = dotenv.env['ImgUrl'] ?? 'http://localhost:3000'; // Correct base URL
    final String encodedPath = Uri.encodeFull(imagePath); // Encode special characters correctly

    // Make sure to combine base URL and path correctly
    final String imageUrl = Uri.parse('$baseUrl/$encodedPath').toString(); // Combine base URL with encoded image path

    // Print the image URL to the console for debugging
    print('path $imageUrl');

    return imagePath.isNotEmpty
        ? GestureDetector(
            onTap: () => _showImageDialog(imageUrl), // Show dialog on image tap
            child: Image.network(
              imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Gambar tidak tersedia'));
              },
            ),
          )
        : const Center(child: Text('Tidak ada gambar'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Topbar(title: 'Pengeluaran Detail ${widget.kategoriKas}'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _response == null
                            ? [const Text('No data available')]
                            : [
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(1),
                                  },
                                  border: TableBorder.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF06B4B5),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '${_response!.details.first.tanggalPengeluaran}',
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            '',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ..._response!.details.map((detail) {
                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              detail.nama,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Rp ${detail.nominal}',
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),

                                    // Add this row to display the image
                                    ..._response!.details.map((detail) {
                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Bukti Pengeluaran',
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: _buildImage(detail.buktiPengeluaran),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0E0E0),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Total Pengeluaran Detail',
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Rp ${_response!.totalNominal}',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                              ],
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}
