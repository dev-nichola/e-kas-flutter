import 'dart:io';

import 'package:e_kas/service/bendahara/pengeluaran/pengeluaran_service.dart';
import 'package:e_kas/service/bendahara/pengeluaran/pengeluaranbulanan_model.dart';
import 'package:e_kas/src/bendahara/ui/home/ui/laporan/pengeluaran/pengeluarandetailpage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../../../service/bendahara/pengeluaran/pengeluarandetail_model.dart';
import '../../../../../../shared/bendahara/navbar_widget.dart';
import '../../../../../../shared/bendahara/topbar_widget.dart';

class PengeluaranBulananPage extends StatefulWidget {
  final String kategoriKas;

  const PengeluaranBulananPage({required this.kategoriKas, Key? key}) : super(key: key);

  @override
  State<PengeluaranBulananPage> createState() => _PengeluaranBulananPageState();
}

class _PengeluaranBulananPageState extends State<PengeluaranBulananPage> {
  int _currentIndex = 0;
  bool _isLoading = true;
  List<Bulanan>? _response;

  @override
  void initState() {
    super.initState();
    _fetchPengeluaranData();
  }

  Future<void> _fetchPengeluaranData() async {
    try {
      final response = await getBulananData(widget.kategoriKas);
      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
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

  void _onTanggalTap(String bulan, int tanggal) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final PengeluaranDetail detail = await getDetailData(widget.kategoriKas, bulan, tanggal);
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PengeluaranDetailPage(
            detail: detail,
            kategoriKas: widget.kategoriKas,
            bulan: bulan,
            tanggal: tanggal,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat detail pengeluaran: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? previousBulan;
    String? previousTahun;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Topbar(title: 'Pengeluaran ${widget.kategoriKas}'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _response == null || _response!.isEmpty
                            ? [const Text('Belum Ada Pengeluaran Bulanan')]
                            : [
                                const SizedBox(height: 16.0),
                                ..._response!.map((item) {
                                  final isSameBulanTahun = item.bulan == previousBulan && item.tahun == previousTahun;
                                  previousBulan = item.bulan;
                                  previousTahun = item.tahun;

                                  // Gunakan Set untuk menghindari duplikasi tanggal
                                  final Set<String> displayedDates = {};

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (!isSameBulanTahun) ...[
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
                                                    '${item.bulan} ${item.tahun}',
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
                                                    'Jumlah',
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
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                      ],
                                      ...item.detail.where((detail) {
                                        // Filter untuk menampilkan hanya 1 tanggal jika ada lebih dari 1 data dengan tanggal yang sama
                                        if (displayedDates.contains(detail.date)) {
                                          return false;
                                        } else {
                                          displayedDates.add(detail.date);
                                          return true;
                                        }
                                      }).map((detail) {
                                        return Table(
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
                                              children: [
                                                GestureDetector(
                                                  onTap: () => _onTanggalTap(item.bulan, int.parse(detail.date)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      '${detail.date} ${item.bulan}',
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Rp ${detail.totalNominal}',
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
                                        );
                                      }).toList(),
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
                                              color: const Color(0xFFE0E0E0),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Total Pengeluaran Bulanan',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Rp ${item.totalNominal}',
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
                                  );
                                }).toList(),
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
