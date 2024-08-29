// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../../../../shared/rt/navbar_widget.dart';
import '../../../../../shared/rt/topbar_widget.dart';

class DataDiriPage extends StatefulWidget {
  const DataDiriPage({super.key});

  @override
  _DataDiriPageState createState() => _DataDiriPageState();
}

class _DataDiriPageState extends State<DataDiriPage> {
  int _currentIndex = 0;

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Topbar(title: 'Data Diri'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Isi Data Diri Anda di sini.',
                   
                    textAlign: TextAlign.center,
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
