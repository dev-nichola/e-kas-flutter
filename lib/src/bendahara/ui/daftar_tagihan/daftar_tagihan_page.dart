// ignore_for_file: library_private_types_in_public_api

import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../shared/bendahara/navbar_widget.dart';
import '../../../shared/bendahara/topbar_widget.dart';
import '../../../../service/bendahara/tagihan/tagihanlist_service.dart';
import '../../../../service/bendahara/tagihan/models/tagihan_model.dart';
import 'payment_method_page.dart'; // Import the payment method page

class BendaharaTagihanPage extends StatefulWidget {
  const BendaharaTagihanPage({super.key});

  @override
  _BendaharaTagihanPageState createState() => _BendaharaTagihanPageState();
}

class _BendaharaTagihanPageState extends State<BendaharaTagihanPage> {
  int _currentIndex = 4;
  Map<String, Map<String, List<Tagihan>>> _tagihanGrouped = {};
  bool _isLoading = true;
  double _totalChecked = 0.0;
  final List<Tagihan> _selectedTagihan = []; // List to hold selected tagihan

  final NumberFormat _currencyFormat = NumberFormat('#,##0', 'id_ID');
  final List<String> _bulanList = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  @override
  void initState() {
    super.initState();
    _fetchTagihanData();
  }

  Future<void> _fetchTagihanData() async {
    try {
      final data = await LaporanKasService.fetchTagihanList();
      setState(() {
        _tagihanGrouped = _groupByMonthAndYear(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, Map<String, List<Tagihan>>> _groupByMonthAndYear(
      List<Tagihan> tagihanList) {
    final Map<String, Map<String, List<Tagihan>>> groupedData = {};

    for (var tagihan in tagihanList) {
      final key = '${tagihan.tahun}';
      if (!groupedData.containsKey(key)) {
        groupedData[key] = {};
      }
      if (!groupedData[key]!.containsKey(tagihan.bulan)) {
        groupedData[key]![tagihan.bulan] = [];
      }
      groupedData[key]![tagihan.bulan]!.add(tagihan);
    }

    groupedData.forEach((key, value) {
      final sortedMap = SplayTreeMap<String, List<Tagihan>>(
        (a, b) => _bulanList.indexOf(a).compareTo(_bulanList.indexOf(b)),
      )..addAll(value);
      groupedData[key] = sortedMap;
    });

    return groupedData;
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _updateTotalChecked() {
    double total = 0.0;
    _selectedTagihan.clear(); // Clear the selected tagihan list

    _tagihanGrouped.forEach((tahun, bulanMap) {
      bulanMap.forEach((bulan, tagihanList) {
        for (var tagihan in tagihanList) {
          if (tagihan.statusPembayaran) {
            // Memastikan tidak null
            total += tagihan.totalTagihan; // Memastikan tidak null
            _selectedTagihan.add(tagihan); // Collect selected tagihan
          }
        }
      });
    });

    setState(() {
      _totalChecked = total;
    });
  }

  void _navigateToPaymentMethod() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodPage(
          totalTagihan: _totalChecked,
          selectedTagihan:
              _selectedTagihan, // Pass selected tagihan to the payment method page
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(title: 'Tagihan'),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: _tagihanGrouped.entries.map((tahunEntry) {
                          final tahun = tahunEntry.key;
                          final bulanMap = tahunEntry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...bulanMap.entries.map((bulanEntry) {
                                final bulan = bulanEntry.key;
                                final tagihanList = bulanEntry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: const Color(0xFF06B4B5),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$bulan $tahun',
                                            style: const TextStyle(
                                              fontSize:
                                                  16, // Mengurangi ukuran font
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columnSpacing:
                                            16.0, // Menambahkan jarak antara kolom
                                        columns: const [
                                          DataColumn(label: Text('')),
                                          DataColumn(label: Text('Kategori')),
                                          DataColumn(
                                              label: Text('Jumlah Tagihan')),
                                        ],
                                        rows: tagihanList.map((tagihan) {
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                Checkbox(
                                                  value:
                                                      tagihan.statusPembayaran,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      tagihan.statusPembayaran =
                                                          value ?? false;
                                                      _updateTotalChecked();
                                                    });
                                                  },
                                                ),
                                              ),
                                              DataCell(Text(tagihan.kategori)),
                                              DataCell(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: Text(
                                                    'Rp ${_currencyFormat.format(tagihan.totalTagihan)}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _navigateToPaymentMethod,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06B4B5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0), // Mengurangi padding
                    textStyle: const TextStyle(
                      fontSize: 14, // Mengurangi ukuran font
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  child: Text(
                    'Total yang harus dibayarkan: Rp ${_currencyFormat.format(_totalChecked)}',
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
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
