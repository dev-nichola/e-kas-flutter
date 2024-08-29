// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:e_kas/src/rt/ui/home/ui/laporan/pemasukan/pemasukanpage.dart';
import 'package:e_kas/src/rt/ui/home/ui/laporan/pengeluaran/pengeluaranpage.dart';
import 'package:e_kas/service/rt/laporan/laporan_service.dart';
import 'package:e_kas/service/rt/laporan/laporan_table_service.dart';
import '../../../../../shared/rt/navbar_widget.dart';
import '../../../../../shared/rt/topbar_widget.dart';


class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  _LaporanPageState createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  late Future<Map<String, dynamic>> _laporanFuture;
  late Future<List<LaporanKategori>> _laporanTableFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _laporanFuture = LaporanService().fetchLaporanGrafik();
    _laporanTableFuture = LaporanTableService().fetchLaporan();
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(0)}M'; // M untuk juta tanpa desimal
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K'; // K untuk ribuan tanpa desimal
    } else {
      return number.toStringAsFixed(0); // Angka di bawah ribuan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _laporanFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            }

            final data = snapshot.data!;
            final pemasukan = data['pemasukan'] as List<Pemasukan>;
            final pengeluaran = data['pengeluaran'] as List<Pengeluaran>;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const Topbar(title: 'LAPORAN'),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              backgroundColor: Colors.amberAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              textStyle: const TextStyle(
                                  fontSize: 16.0, color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
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
                                  builder: (context) => const PengeluaranPage(), // Arahkan ke PengeluaranPage
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amberAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 15.0),
                              textStyle: const TextStyle(fontSize: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
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
                    child: Column(
                      children: [
                        // Kartu Total Saldo
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Saldo',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'Rp.${_formatNumber(data['totalSaldo'])}',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        _buildBarChart('Pemasukan', Colors.green, pemasukan),
                        const SizedBox(height: 32.0),
                        _buildBarChart('Pengeluaran', Colors.red, pengeluaran),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarTap,
      ),
    );
  }

  Widget _buildBarChart(String title, Color barColor, List<dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 200.0,
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8.0,
                        child: Text(
                          data[index].bulan,
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8.0,
                        child: Text(
                          _formatNumber(value),
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: data.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: item.nominal.toDouble(), // Pastikan nominal adalah double
                      color: barColor,
                      width: 16.0,
                      borderRadius:
                          BorderRadius.circular(4.0), // Rounded corners
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
