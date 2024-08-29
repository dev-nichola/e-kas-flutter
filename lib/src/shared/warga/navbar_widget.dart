import 'package:flutter/material.dart';
import 'package:e_kas/src/warga/ui/daftar_tagihan/daftar_tagihan_page.dart';
import 'package:e_kas/src/warga/ui/data_diri/data_diri_page.dart';
import 'package:e_kas/src/warga/ui/home/wargahomepage.dart';
import 'package:e_kas/src/warga/ui/kas_agustusan/kas_agustusan_page.dart';
import 'package:e_kas/src/warga/ui/kas_bulanan/kas_bulanan_page.dart';
import 'package:e_kas/src/warga/ui/kas_sinoman/kas_sinoman_page.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Navbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const WargaHomePage(),
      const WargaSinomanPage(kategoriKas: 'Sinoman'),
      const WargaAgustusanPage(kategoriKas: 'Agustusan'),
      const WargaBulananPage(kategoriKas: 'Bulanan'),
      const WargaTagihanPage(),
      const WargaDataDiriPage(),
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 2.0, color: Color(0xFF06B4B5)),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF06B4B5),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => pages[index]),
            );
            onTap(index);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Sinoman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Agustusan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bulanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.launch),
            label: 'Tagihan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Data Diri',
          ),
        ],
      ),
    );
  }
}
