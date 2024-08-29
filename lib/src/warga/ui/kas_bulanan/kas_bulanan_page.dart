// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:e_kas/src/shared/warga/navbar_widget.dart';
import 'package:e_kas/src/shared/warga/topbar_widget.dart';
import '../../../../service/warga/laporankas_service.dart';
import 'components/rounded_card.dart';
import 'components/label.dart';
import 'components/years_card.dart';
import 'components/month_card.dart';




class WargaBulananPage extends StatefulWidget {
  final String kategoriKas; // Parameter yang diperlukan

  const WargaBulananPage({super.key, required this.kategoriKas});

  @override
  _WargaBulananPageState createState() => _WargaBulananPageState();
}

class _WargaBulananPageState extends State<WargaBulananPage> {
  bool _showMonths = false;
  int _selectedMonth = -1;
  int _currentIndex = 3;
  bool _isLoading = false;
  Map<String, dynamic>? _laporanKas;
  late String _currentYear;

  @override
  void initState() {
    super.initState();
    _currentYear = DateTime.now().year.toString(); // Set default tahun
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.width / 4;
    double cardWidth = MediaQuery.of(context).size.width / 4;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(title: 'Bulanan'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedCard(
                            title: 'KAS BULANAN',
                            width: MediaQuery.of(context).size.width * 0.9,
                            background: const Color(0xFFD8AF5C),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_laporanKas != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Label(
                              title: 'TOTAL',
                              width: 150,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Label(
                              title: 'Rp.${_laporanKas!['bersih']}',
                              width: 150,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (!_showMonths)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showMonths = !_showMonths;
                                });
                              },
                              child: MonthCard(
                                title: _selectedMonth == -1
                                    ? 'Pilih Bulan'
                                    : _monthName(_selectedMonth + 1),
                                width: MediaQuery.of(context).size.width * 0.9,
                                background: const Color(0xFFE4E2DF),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      if (_showMonths)
                        Container(
                          color: Colors.grey[300],
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  YearsCard(
                                    title: 'Tahun $_currentYear',
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    background: const Color(0xFFD8AF5C),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 12,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        _selectedMonth = index;
                                        _showMonths =
                                            false; // Hide months after selection
                                        _isLoading =
                                            true; // Show loading indicator
                                      });
                                      try {
                                        final month = _monthName(index + 1);
                                        final year = _currentYear;
                                        final kategoriKas =
                                            widget.kategoriKas; // Use parameter

                                        final laporanKas =
                                            await LaporanKasService
                                                .fetchLaporanKas(
                                          bulan: month,
                                          tahun: year,
                                          kategoriKas: kategoriKas,
                                        );
                                        setState(() {
                                          _laporanKas = laporanKas;
                                        });
                                      } catch (e) {
                                        // Handle error
                                      } finally {
                                        setState(() {
                                          _isLoading =
                                              false; // Hide loading indicator
                                        });
                                      }
                                    },
                                    child: SizedBox(
                                      height: cardHeight,
                                      width: cardWidth,
                                      child: Card(
                                        color: _selectedMonth == index
                                            ? const Color(0xFF06B4B5)
                                            : Colors.grey[300],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _monthName(index + 1),
                                            style: TextStyle(
                                              color: _selectedMonth == index
                                                  ? Colors.white
                                                  : const Color(0xFF06B4B5),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (_isLoading) ...[
                        const Center(child: CircularProgressIndicator()),
                      ] else if (_laporanKas != null) ...[
                        Card(
                          color: Colors.grey[300],
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Pemasukan',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      'Rp.${_laporanKas!['totalPemasukan']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors
                                            .green, // Warna hijau untuk nilai pemasukan
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors
                                      .green, // Warna hijau untuk garis pembatas
                                  thickness: 2,
                                ),
                                Column(
  children: (_laporanKas!['pemasukan'] as List<dynamic>)
      .map((item) {
    // Pastikan item adalah Map<String, dynamic>
    if (item is Map<String, dynamic>) {
      final pemasukan = Pemasukan.fromJson(item);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(pemasukan.date,
                style: const TextStyle(fontSize: 14)),
            Text('Rp.${pemasukan.totalNominal}',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      );
    } else {
      // Tangani jika item bukan Map<String, dynamic>
      return SizedBox.shrink(); // Atau widget lain yang sesuai
    }
  }).toList(),
),
                                const Divider(
                                  color: Colors
                                      .green, // Warna hijau untuk garis pembatas
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Pengeluaran',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      '-Rp.${_laporanKas!['totalPengeluaran']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 86, 65, 64), // Warna merah untuk nilai pengeluaran
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors
                                      .green, // Warna merah untuk garis pembatas
                                  thickness: 2,
                                ),
                                Column(
                                  children: (_laporanKas!['pengeluaran']
                                          as List<Pengeluaran>)
                                      .map((pengeluaranItem) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(pengeluaranItem.nama,
                                              style: const TextStyle(
                                                  fontSize: 14,fontWeight: FontWeight.normal,)),
                                          Text('-Rp.${pengeluaranItem.nominal}',
                                              style: const TextStyle(
                                                   fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors
                                            .red)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const Divider(
                                  color: Colors
                                      .green, // Warna merah untuk garis pembatas
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Saldo',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      'Rp.${_laporanKas!['bersih']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                
                              ],
                              
                            ),
                            
                          ),
                        ),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    RoundedCard(
      title: 'Total Saldo per ${_monthName(_selectedMonth + 1)} $_currentYear Rp ${_laporanKas!['bersih']}',
      width: MediaQuery.of(context).size.width * 0.9,
      background: const Color(0xFF06B4B5),
    ),
  ],
),
const SizedBox(height: 10),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    RoundedCard(
      title: 'Total Saldo bulan sebelumnya ${_monthName(_selectedMonth == 0 ? 12 : _selectedMonth)} $_currentYear Rp ${_laporanKas!['bersihBulanSebelum']}',
      width: MediaQuery.of(context).size.width * 0.9,
      background: const Color(0xFFB0B0B0),
      style: const TextStyle(color: Colors.black), // Mengatur warna teks
    ),
  ],
),


                      ] else ...[
                        const Center(
                            child: Text(
                                'Silakan pilih bulan untuk melihat laporan.')),
                      ],
                      const SizedBox(height: 10),
                    ],
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

  String _monthName(int month) {
    const months = [
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
    return months[month - 1];
  }
}
