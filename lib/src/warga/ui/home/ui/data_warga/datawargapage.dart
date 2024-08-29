import 'package:flutter/material.dart';
import '../../../../../shared/rt/navbar_widget.dart';

class DataWargaPage extends StatefulWidget {
  const DataWargaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataWargaPageState createState() => _DataWargaPageState();
}

class _DataWargaPageState extends State<DataWargaPage> {
  int _currentIndex = 0;

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DATA WARGA',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF06B4B5),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Halaman Data Warga'),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}
