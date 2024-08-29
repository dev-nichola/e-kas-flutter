import 'package:e_kas/src/bendahara/ui/home/ui/inputpengeluaran/inputpengeluaranpage.dart';
import 'package:e_kas/src/bendahara/ui/home/ui/laporan/laporanpage.dart';
import 'package:e_kas/src/bendahara/ui/home/ui/tagihan_warga/tagihanwargapage.dart';

import 'package:flutter/material.dart';
import 'components/card_widgets.dart';
import 'components/keterangan_card_widget.dart';
import '../../../shared/bendahara/navbar_widget.dart'; 
import '../../../shared/bendahara/topbar_widget.dart'; 

class BendaharaHomePage extends StatefulWidget {
  const BendaharaHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BendaharaHomePageState createState() => _BendaharaHomePageState();
}

class _BendaharaHomePageState extends State<BendaharaHomePage> {
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
            const Topbar(title: 'bendahara home'),
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
                                MaterialPageRoute(builder: (context) => const InputPengeluaranPage()),
                              );
                            },
                            child: buildCard('Input Pengeluaran', Icons.outbox, 120),
                          ),
                         GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const BendaharaLaporanPage()),
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
                            child: buildCard('Tagihan Warga', Icons.stacked_bar_chart_sharp, 120),
                          ),
                        ],
                      ),
                    
                    
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildRoundedCard('Kas Sinoman', null, MediaQuery.of(context).size.width * 0.9),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildKeteranganCard('Kas Sinom', Icons.info, MediaQuery.of(context).size.width * 0.9),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildRoundedCard('Kas Agutusan', null, MediaQuery.of(context).size.width * 0.9),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildKeteranganCard('Kas Agustusan', Icons.flag, MediaQuery.of(context).size.width * 0.9),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildRoundedCard('Kas Bulanan', null, MediaQuery.of(context).size.width * 0.9),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildKeteranganCard('Kas Bulanan', Icons.calendar_today, MediaQuery.of(context).size.width * 0.9),
                        ],
                      ),
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
