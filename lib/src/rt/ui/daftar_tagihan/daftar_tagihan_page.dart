// ignore_for_file: library_private_types_in_public_api

import 'package:e_kas/service/rt/daftar_tagihan_service.dart';
import 'package:flutter/material.dart';
import '../../../shared/rt/navbar_widget.dart';
import '../../../shared/rt/topbar_widget.dart';
import 'tambah_tagihan_page.dart'; // Ensure this import points to the correct file for TambahTagihanPage

class TagihanPage extends StatefulWidget {
  const TagihanPage({super.key});

  @override
  _TagihanPageState createState() => _TagihanPageState();
}

class _TagihanPageState extends State<TagihanPage> {
  int _currentIndex = 4;
  late Future<List<dynamic>> _tagihanData;

  @override
  void initState() {
    super.initState();
    _tagihanData = getTagihanData();
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddTagihan() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const TambahTagihanPage(),
    ),
  );

  if (result == true) {
    setState(() {
      _tagihanData = getTagihanData(); // Refresh the data
    });
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          const Topbar(title: 'BUAT TAGIHAN'),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _onAddTagihan, // Updated method call
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<dynamic>>(
                future: _tagihanData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data tagihan.'));
                  } else {
                    final data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final tagihan = data[index];
                        final kategoriKas = tagihan['kategoriKas'] ?? 'No category';
                        final bulanMulai = tagihan['bulanMulai'] ?? 'No start month';
                        final bulanBerakhir = tagihan['bulanBerakhir'] ?? 'No end month';
                        final nominalKas = tagihan['nominalKas'] ?? 0;

                        return Card(
                          color: const Color(0xFF06B4B5),
                          child: ListTile(
                            leading: const Icon(
                              Icons.payment,
                              color: Color(0xFFD8AF5C),
                              size: 50, // Increased icon size
                            ),
                            title: Text(
                              kategoriKas,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22, // Increased font size
                              ),
                            ),
                            subtitle: Text(
                              '$bulanMulai - $bulanBerakhir\nRp.${nominalKas.toString()}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
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

}