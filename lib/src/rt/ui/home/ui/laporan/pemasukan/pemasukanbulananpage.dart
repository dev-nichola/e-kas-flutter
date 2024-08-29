import 'package:flutter/material.dart';
import 'package:e_kas/service/rt/pemasukan/pemasukanbulanan_model.dart';
import 'package:e_kas/service/rt/pemasukan/pemasukan_service.dart';
import '../../../../../../shared/rt/navbar_widget.dart';
import '../../../../../../shared/rt/topbar_widget.dart';
import 'package:e_kas/service/rt/pemasukan/pemasukandetail_model.dart'; // Adjust the path accordingly

import 'package:e_kas/src/rt/ui/home/ui/laporan/pemasukan/pemasukandetailpage.dart';

class PemasukanBulananPage extends StatefulWidget {
  final String kategoriKas;

  const PemasukanBulananPage({required this.kategoriKas, Key? key})
      : super(key: key);

  @override
  State<PemasukanBulananPage> createState() => _PemasukanBulananPageState();
}

class _PemasukanBulananPageState extends State<PemasukanBulananPage> {
  int _currentIndex = 0;
  bool _isLoading = true;
  List<Bulanan>? _response;

  @override
  void initState() {
    super.initState();
    _fetchPemasukanData();
  }

  Future<void> _fetchPemasukanData() async {
    try {
      final response = await getBulananData(widget.kategoriKas);
      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching Pemasukan data: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data Pemasukan: $e')),
      );
    }
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTanggalTap(String bulan, int tanggal) async {
    try {
      // Fetch the detail data
      final detail = await getDetailData(widget.kategoriKas, bulan, tanggal);

      // Navigate to PemasukanDetailPage with the fetched data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PemasukanDetailPage(
            kategoriKas: widget.kategoriKas,
            bulan: bulan,
            tanggal: tanggal,
          ),
        ),
      );
    } catch (e) {
      print('Error fetching Pemasukan detail: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat detail pemasukan: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Topbar(title: 'Pemasukan Bulanan ${widget.kategoriKas}'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _response == null || _response!.isEmpty
                            ? [const Text('Belum ada Pemasukan Bulanan')]
                            : [
                                const SizedBox(height: 16.0),
                                ..._response!.map((item) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
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
                                          ...item.detail.map((detail) {
                                            return TableRow(
                                              children: [
                                                GestureDetector(
                                                  onTap: () => _onTanggalTap(item.bulan, int.parse(detail.date.split(' ')[0])),
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
                                            );
                                          }).toList(),
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE0E0E0),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Total Pemasukan Bulanan',
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
