import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl untuk format angka
import '../../../../../shared/bendahara/navbar_widget.dart';
import '../../../../../shared/bendahara/topbar_widget.dart';
import 'package:e_kas/service/bendahara/input_pengeluaran_service.dart';
import 'package:e_kas/src/bendahara/ui/home/ui/inputpengeluaran/tambahpengeluaranpage.dart';

class InputPengeluaranPage extends StatefulWidget {
  const InputPengeluaranPage({super.key});

  @override
  _InputPengeluaranPageState createState() => _InputPengeluaranPageState();
}

class _InputPengeluaranPageState extends State<InputPengeluaranPage> {
  int _currentIndex = 0;
  Future<List<dynamic>?>? _pengeluaranData;

  @override
  void initState() {
    super.initState();
    _pengeluaranData = getPengeluaranData() as Future<List?>?;
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TambahPengeluaranPage()),
    );
    print('Tambah Pengeluaran');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(title: 'Input Pengeluaran Kas'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _onAddExpense,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF154D4D), // Warna teks tombol
                    ),
                    child: const Text('Tambah Pengeluaran'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<dynamic>?>(
                  future: _pengeluaranData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Data Pengeluaran Belum Tersedia.'));
                    } else {
                      final data = snapshot.data!;
                      final formatter = NumberFormat('#,##0'); // Format angka tanpa digit di belakang koma

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ...data.map<Widget>((item) {
                              final month = item['bulan'];
                              final year = item['tahun'];
                              final expenses = (item['dataPengeluaran'] as List<dynamic>).map<Widget>((expense) {
                                final date = expense['date'];
                                final nominal = expense['nominal'];
                                return _buildExpenseRow(date, '-Rp.${formatter.format(nominal)}');
                              }).toList();
                              final total = '-Rp.${formatter.format(item['totalPengeluaran'])}';
                              return _buildExpenseCard(month, year, expenses, total);
                            }),
                          ],
                        ),
                      );
                    }
                  },
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

  Widget _buildExpenseCard(String month, String year, List<Widget> expenses, String total) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Color(0xFF06B4B5), // Warna latar belakang bulan
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Row(
                children: [
                  Text(
                    '$month $year',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Warna teks bulan dan tahun
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0), // Jarak antara label dan data pengeluaran
            ...expenses,
            const SizedBox(height: 8.0), // Jarak antara data pengeluaran dan total
            Row(
              children: [
                const Text(
                  'Total Pengeluaran Bulanan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Spacer(), // Untuk memisahkan label dan total
                Text(
                  total,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseRow(String date, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
