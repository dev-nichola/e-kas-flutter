import 'package:e_kas/src/rt/ui/home/ui/laporan/pemasukan/pemasukanbulananpage.dart';
import 'package:e_kas/src/rt/ui/home/ui/laporan/pengeluaran/pengeluaranpage.dart';
import 'package:flutter/material.dart';
import 'package:e_kas/service/rt/pemasukan/pemasukan_model.dart';
import 'package:e_kas/service/rt/pemasukan/pemasukan_service.dart';
import '../../../../../../shared/rt/navbar_widget.dart';
import '../../../../../../shared/rt/topbar_widget.dart';

class PemasukanPage extends StatefulWidget {
  const PemasukanPage({super.key});

  @override
  State<PemasukanPage> createState() => _PemasukanPageState();
}

class _PemasukanPageState extends State<PemasukanPage> {
  int _currentIndex = 0;
  bool _isLoading = true;
  PemasukanResponse? _response;

  @override
  void initState() {
    super.initState();
    _fetchPemasukanData();
  }

  Future<void> _fetchPemasukanData() async {
    try {
      final response = await getPemasukanData();
      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data pemasukan: $e')),
      );
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Topbar(title: 'History Pemasukan'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PemasukanPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF06B4B5),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Color(0xFF06B4B5)),
                          ),
                        ),
                        child: const Text('Pemasukan'),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PengeluaranPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF06B4B5),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(color: Color(0xFF06B4B5)),
                          ),
                        ),
                        child: const Text('Pengeluaran'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _response == null
                            ? [const Text('No data available')]
                            : [
                                _response!.kasHariIni.isNotEmpty
                                    ? Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF06B4B5),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 4.0,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Pemasukan Hari ini',
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const Text(
                                        'Tidak ada pemasukan hari ini.'),
                                const SizedBox(height: 16.0),
                                // Iterate over all items in kasHariIni
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(2), // Kas column width
                                    1: FlexColumnWidth(1), // Jumlah column width
                                  },
                                  border: TableBorder.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 1,
                                  ),
                                  children: [
                                    // Header row
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF06B4B5),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Kas',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
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
                                    // Data rows
                                    ..._response!.kasHariIni.map((kas) {
                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              kas.kategoriKas,
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Rp ${kas.totalNominal}',
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                ..._response!.data.map((item) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4.0,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.kategoriKas,
                                                style: const TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                 Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PemasukanBulananPage(
                                                      kategoriKas: item.kategoriKas,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Selengkapnya',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Total Kas: Rp ${item.bersihKas}',
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8.0),
                                        ...item.details.map((detail) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      '${detail.bulan} ${detail.tahun}'),
                                                ),
                                                Text(
                                                  'Rp ${detail.totalNominal}',
                                                  style: const TextStyle(
                                                      color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Total Pemasukan: Rp ${item.totalNominal}',
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
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
