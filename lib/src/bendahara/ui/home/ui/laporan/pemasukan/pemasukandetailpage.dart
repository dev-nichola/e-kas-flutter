import 'package:flutter/material.dart';
import 'package:e_kas/service/bendahara/pemasukan/pemasukan_service.dart';
import 'package:e_kas/service/bendahara/pemasukan/pemasukandetail_model.dart'; // Ensure this model is correct

import '../../../../../../shared/bendahara/navbar_widget.dart';
import '../../../../../../shared/bendahara/topbar_widget.dart';

class PemasukanDetailPage extends StatefulWidget {
  final String kategoriKas;
  final String bulan;
  final int tanggal;

  const PemasukanDetailPage({
    required this.kategoriKas,
    required this.bulan,
    required this.tanggal,
    Key? key,
  }) : super(key: key);

  @override
  State<PemasukanDetailPage> createState() => _PemasukanDetailPageState();
}

class _PemasukanDetailPageState extends State<PemasukanDetailPage> {
  bool _isLoading = true;
  PemasukanDetail? _response;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchPemasukanData();
  }

  Future<void> _fetchPemasukanData() async {
    try {
      // Call the function to get Pemasukan detail data
      final response = await getDetailData(widget.kategoriKas, widget.bulan, widget.tanggal);

      // Update state with the fetched data
      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
      // Print error message for debugging
      print('Error fetching Pemasukan data: $e');

      // Update state to indicate data loading failed
      setState(() {
        _isLoading = false;
      });

      // Show error message using SnackBar
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Topbar(title: 'Pemasukan Detail ${widget.kategoriKas}'),
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
                                            '${_response!.date}',
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
                                    ..._response!.user.map((user) { // Update from details to user
                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${user.namaLengkap}', // Update field name
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Rp ${user.nominal}', // No changes needed
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
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE0E0E0),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Total Uang Kas Harian',
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
                                              color: Colors.green,
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
