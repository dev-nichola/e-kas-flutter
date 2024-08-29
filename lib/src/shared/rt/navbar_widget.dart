import 'package:flutter/material.dart';
import '../../rt/ui/home/rthomepage.dart';
import '../../rt/ui/kas_sinoman/kas_sinoman_page.dart';
import '../../rt/ui/daftar_tagihan/daftar_tagihan_page.dart';
import '../../rt/ui/data_diri/data_diri_page.dart';
import '../../rt/ui/kas_agustusan/kas_agustusan_page.dart';
import '../../rt/ui/kas_bulanan/kas_bulanan_page.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Navbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const RtHomePage(),

      const SinomanPage(kategoriKas: 'Sinoman'),
      const AgustusanPage(kategoriKas: 'Agustusan'),
      const BulananPage(kategoriKas: 'Bulanan'),
      const TagihanPage(),
      const DataDiriPage(),
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
          // Ensure the new page replaces the current page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => pages[index]),
          );
          // Notify parent widget about the change
          onTap(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.launch),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
