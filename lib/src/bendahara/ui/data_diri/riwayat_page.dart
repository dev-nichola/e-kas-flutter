import 'package:e_kas/src/bendahara/ui/data_diri/riwayatdetailpage.dart';
import 'package:flutter/material.dart';
import '../../../shared/bendahara/navbar_widget.dart';
import '../../../shared/bendahara/topbar_widget.dart';

class BendaharaRiwayatPage extends StatefulWidget {
  const BendaharaRiwayatPage({super.key, required this.riwayatData, required this.diriId});

  final List<Map<String, dynamic>> riwayatData;
  final String? diriId;

  @override
  _BendaharaRiwayatPageState createState() => _BendaharaRiwayatPageState();
}

class _BendaharaRiwayatPageState extends State<BendaharaRiwayatPage> {
  int _currentIndex = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Topbar(title: 'Riwayat'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.riwayatData.isEmpty
                    ? const Center(child: Text('No data found'))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columns: const [
                              DataColumn(
                                label: Expanded(
                                  child: Text('Pembayaran Kas', textAlign: TextAlign.center),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text('Status', textAlign: TextAlign.center),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text('Nominal', textAlign: TextAlign.center),
                                ),
                              ),
                            ],
                            rows: widget.riwayatData.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(item['date'] ?? '', textAlign: TextAlign.center),
                                    onTap: () {
                                      final idPembayaran = item['id'] ?? 'Unknown ID';
                                      print('ID Pembayaran yang diklik: $idPembayaran'); // Debugging line
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailRiwayatPage(
                                            detailPembayaranId: idPembayaran,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  DataCell(
                                    Text(item['status'] ?? '', textAlign: TextAlign.center),
                                  ),
                                  DataCell(
                                    Text(
                                      item['totalNominal']?.toString() ?? '',
                                      style: TextStyle(
                                        color: item['status'] == 'Berhasil' ? Colors.green : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
