// ignore_for_file: library_private_types_in_public_api

import 'package:e_kas/service/token_service.dart';
import 'package:flutter/material.dart';

import 'components/card_widgets.dart';
import 'components/keterangan_card_widget.dart';
import '../../../shared/warga/navbar_widget.dart';
import '../../../shared/warga/topbar_widget.dart';

class WargaHomePage extends StatefulWidget {
  const WargaHomePage({super.key});

  @override
  _WargaHomePageState createState() => _WargaHomePageState();
}

class _WargaHomePageState extends State<WargaHomePage> {
  int _currentIndex = 0;
  String _fullName = '';

  @override
  void initState() {
    super.initState();
    _loadFullName();
  }

  Future<void> _loadFullName() async {
    String fullName = await TokenService.getFullName();
    setState(() {
      _fullName = fullName;
    });
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
            children: [
              const Topbar(title: 'Warga Home'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/image/cover.jpg', 
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    buildTitleCard('Selamat datang di SATRYAKAS kembali, $_fullName'),
                    const SizedBox(height: 16.0),
                    buildRoundedCard('Kas Sinoman', null, MediaQuery.of(context).size.width * 0.9),
                    const SizedBox(height: 5.0),
                    buildKeteranganCard('Kas Sinom', Icons.info, MediaQuery.of(context).size.width * 0.9),
                    const SizedBox(height: 16.0),
                    buildRoundedCard('Kas Agustusan', null, MediaQuery.of(context).size.width * 0.9),
                    const SizedBox(height: 5.0),
                    buildKeteranganCard('Kas Agustusan', Icons.flag, MediaQuery.of(context).size.width * 0.9),
                    const SizedBox(height: 16.0),
                    buildRoundedCard('Kas Bulanan', null, MediaQuery.of(context).size.width * 0.9),
                    const SizedBox(height: 5.0),
                    buildKeteranganCard('Kas Bulanan', Icons.calendar_today, MediaQuery.of(context).size.width * 0.9),
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

  Widget buildTitleCard(String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF06B4B5),
        borderRadius: BorderRadius.zero, // Menghapus sudut rounded
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildCardRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: buildRoundedCard(
            title, 
            null,
            MediaQuery.of(context).size.width * 0.9,
          ),
        ),
      ],
    );
  }

  Widget buildKeteranganCardRow(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: buildKeteranganCard(
            title,
            icon,
            MediaQuery.of(context).size.width * 0.9,
          ),
        ),
      ],
    );
  }
}
