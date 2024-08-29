import 'package:e_kas/service/warga/datadiri_service.dart';
import 'package:flutter/material.dart';
import '../../../shared/warga/navbar_widget.dart';
import '../../../shared/warga/topbar_widget.dart';

class DetailRiwayatPage extends StatefulWidget {
  const DetailRiwayatPage({super.key, required this.detailPembayaranId});

  final String detailPembayaranId;

  @override
  _DetailRiwayatPageState createState() => _DetailRiwayatPageState();
}

class _DetailRiwayatPageState extends State<DetailRiwayatPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final data = await detailRiwayat(widget.detailPembayaranId);
      setState(() {
        _detailData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat detail riwayat: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(title: 'Detail Riwayat'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _detailData == null
                        ? const Center(child: Text('Tidak ada detail data ditemukan'))
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          _detailData!['date'] ?? 'N/A',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ),
                                      const DataColumn(
                                        label: Text(
                                          '',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 2),
                                        ),
                                      ),
                                      const DataColumn(
                                        label: Text(
                                          '',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 2),
                                        ),
                                      ),
                                    ],
                                    rows: (_detailData!['detailPembayaran'] as List<dynamic>? ?? []).map((detail) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(detail['kategoriKas'] ?? 'N/A', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                                          ),
                                          DataCell(
                                            Text(detail['date'] ?? 'N/A', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                                          ),
                                          DataCell(
                                            Text(detail['nominal']?.toString() ?? 'N/A', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navbar tap
        },
      ),
    );
  }
}
