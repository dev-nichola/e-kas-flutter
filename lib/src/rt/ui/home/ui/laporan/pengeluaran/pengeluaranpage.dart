import 'package:e_kas/src/rt/ui/home/ui/laporan/pemasukan/pemasukanpage.dart';
import 'package:flutter/material.dart';
import 'package:e_kas/service/rt/pengeluaran/pengeluaran_model.dart';
import 'package:e_kas/service/rt/pengeluaran/pengeluaran_service.dart';
import '../../../../../../shared/rt/navbar_widget.dart';
import '../../../../../../shared/rt/topbar_widget.dart';
import 'pengeluaranbulananpage.dart';

class PengeluaranPage extends StatefulWidget {
  const PengeluaranPage({super.key});

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  int _currentIndex = 0;
  bool _isLoading = true;
  PengeluaranResponse? _response;

  @override
  void initState() {
    super.initState();
    _fetchPengeluaranData();
  }

  Future<void> _fetchPengeluaranData() async {
    try {
      final response = await getPengeluaranData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Topbar(title: 'History Pengeluaran'),
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
                              builder: (context) => const PengeluaranPage(),
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
      : _response == null || _response!.kasHariIni.isEmpty
          ? const Text('Tidak ada Pengeluaran hari ini.')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF06B4B5),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Pengeluaran Hari ini',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
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
                                color: Colors.red,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.kategoriKas,
                                style: const TextStyle(
                                    fontSize: 18.0, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PengeluaranBulananPage(
                                      kategoriKas: item.kategoriKas,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Selengkapnya',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Total Kas: Rp ${item.bersihKas}',
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        ...item.details.map((detail) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      '${detail.bulan} ${detail.tahun}'),
                                ),
                                Text(
                                  'Rp ${detail.totalNominal}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 8.0),
                        Text(
                          'Total Pengeluaran: Rp ${item.totalNominal}',
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
)

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