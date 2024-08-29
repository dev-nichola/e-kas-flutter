// ignore_for_file: use_build_context_synchronously

import 'package:e_kas/service/rt/daftar_tagihan_service.dart';
import 'package:flutter/material.dart';
import '../../../shared/rt/navbar_widget.dart';
import '../../../shared/rt/topbar_widget.dart';

class TambahTagihanPage extends StatefulWidget {
  const TambahTagihanPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TambahTagihanPageState createState() => _TambahTagihanPageState();
}

class _TambahTagihanPageState extends State<TambahTagihanPage> {
  int _currentIndex = 4;
  final _kategoriKasList = ['Bulanan', 'Agustusan', 'Sinoman'];
  String _selectedKategoriKas = 'Bulanan';
  final _nominalController = TextEditingController();

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

Future<void> _submitTagihan() async {
  final nominalKas = int.tryParse(_nominalController.text) ?? 0;

  // if (nominalKas < 10000) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Nominal Kas harus minimal 10.000.'),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  //   return;
  // }

  try {
    await createTagihanData(_selectedKategoriKas, nominalKas);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tagihan berhasil ditambahkan.')),
    );
    Navigator.pop(context, true); // Pass `true` to indicate success
  } catch (e) {
    final errorMessage = e.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pemberitahuan'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(title: 'Tambah Tagihan'),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedKategoriKas,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedKategoriKas = newValue;
                        });
                      }
                    },
                    items: _kategoriKasList.map((kategori) {
                      return DropdownMenuItem<String>(
                        value: kategori,
                        child: Text(kategori),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'Kategori Kas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _nominalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Nominal Kas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _submitTagihan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF154D4D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      textStyle: const TextStyle(fontSize: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Tambah Tagihan'),
                  ),
                ],
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
