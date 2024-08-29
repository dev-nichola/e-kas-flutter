// ignore_for_file: library_private_types_in_public_api

import 'package:e_kas/src/rt/ui/home/ui/daftar_tagihan/daftar_tagihan_page.dart';

import 'package:e_kas/src/rt/ui/home/ui/tagihan_warga/tagihanwargapage.dart';
import 'package:flutter/material.dart';
import 'package:e_kas/src/rt/ui/home/ui/laporan/laporanpage.dart';
import './ui/data_warga/datawargapage.dart';
import '../../../shared/rt/navbar_widget.dart'; 
import '../../../shared/rt/topbar_widget.dart'; 
import 'components/card_widgets.dart';
import 'components/keterangan_card_widget.dart';

class RtHomePage extends StatefulWidget {
  const RtHomePage({super.key});

  @override
  _RtHomePageState createState() => _RtHomePageState();
}

class _RtHomePageState extends State<RtHomePage> {
  int _currentIndex = 0;

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(title: '',isBackButtonEnabled: false),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DataWargaPage()),
                              );
                            },
                            child: buildCard('Data Warga', Icons.people, 120),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LaporanPage()),
                              );
                            },
                            child: buildCard('Laporan', Icons.stacked_bar_chart_sharp, 120), 
                          ),
                           GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TagihanWargaPage()),
                              );
                            },
                            child: buildCard('Tagihan Warga', Icons.payment, 120), 
                          ),
                          
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TagihanPage()),
                              );
                            },
                            child: buildCard('Buat Tagihan', Icons.launch, 120),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      buildRoundedCard('Kas Sinoman', null, MediaQuery.of(context).size.width * 0.9),
                      const SizedBox(height: 16.0),
                      buildKeteranganCard('Kas Sinom', Icons.info, MediaQuery.of(context).size.width * 0.9),
                      const SizedBox(height: 16.0),
                      buildRoundedCard('Kas Agutusan', null, MediaQuery.of(context).size.width * 0.9),
                      const SizedBox(height: 16.0),
                      buildKeteranganCard('Kas Agustusan', Icons.flag, MediaQuery.of(context).size.width * 0.9),
                      const SizedBox(height: 16.0),
                      buildRoundedCard('Kas Bulanan', null, MediaQuery.of(context).size.width * 0.9),
                      const SizedBox(height: 16.0),
                      buildKeteranganCard('Kas Bulanan', Icons.calendar_today, MediaQuery.of(context).size.width * 0.9),
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
        onTap: _onNavbarTap,
      ),
    );
  }
}
