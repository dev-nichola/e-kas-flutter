// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:e_kas/service/rt/datawarga_service.dart';
import 'package:e_kas/src/rt/ui/home/ui/data_warga/updatewargapage.dart';
import 'tambahwargapage.dart';
import '../../../../../shared/rt/navbar_widget.dart';
import '../../../../../shared/rt/topbar_widget.dart';

class DataWargaPage extends StatefulWidget {
  const DataWargaPage({super.key});

  @override
  _DataWargaPageState createState() => _DataWargaPageState();
}

class _DataWargaPageState extends State<DataWargaPage> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final GetWargaService _wargaService = GetWargaService();
  final DeleteWargaService _deleteWargaService = DeleteWargaService();
  List<dynamic> _wargaList = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchWarga();
    _searchController.addListener(_onSearchChange);
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _deleteWarga(String id) async {
    final success = await _deleteWargaService.deleteWarga(id);
    if (success) {
      _fetchWarga();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Warga berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus warga')),
      );
    }
  }

  void _confirmDeleteWarga(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus warga ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteWarga(id);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _fetchWarga({String query = ''}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final wargaList = await _wargaService.getWarga(query: query);
      setState(() {
        _wargaList = wargaList;
      });
    } catch (e) {
      setState(() {
        _wargaList = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _fetchWarga(query: _searchQuery);
  }

  void _onSearchChange() {
    final currentQuery = _searchController.text;
    if (currentQuery != _searchQuery) {
      setState(() {
        _searchQuery = currentQuery;
      });
      if (currentQuery.isEmpty) {
        _fetchWarga();
      } else {
        _fetchWarga(query: currentQuery);
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChange);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(title: 'DATA WARGA'),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded(
                  //   flex: 2,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.amber,
                  //       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  //       textStyle: const TextStyle(fontSize: 10.0),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10.0),
                  //       ),
                  //     ),
                  //     child: const Text('Cari Warga'),
                  //   ),
                  // ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: SizedBox(
                      width: 10,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TambahWargaPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                          textStyle: const TextStyle(fontSize: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Tambah Warga'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Cari Warga',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: _onSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 8.0),
                      textStyle: const TextStyle(fontSize: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Cari'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _wargaList.isEmpty
                      ? const Center(child: Text('No data found'))
                      : ListView.builder(
                          itemCount: _wargaList.length,
                          itemBuilder: (context, index) {
                            final warga = _wargaList[index];
                            return Card(
                              margin: const EdgeInsets.all(16.0),
                              color: const Color(0xFF06B4B5),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    warga['nama_Lengkap'][0],
                                    style: const TextStyle(
                                      fontSize: 30.0,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  warga['nama_Lengkap'],
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                                subtitle: Text(
                                  warga['alamat_Lengkap'],
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _confirmDeleteWarga(
                                            warga['id'].toString());
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateWargaPage(
                                                    wargaId:
                                                        warga['id'].toString()),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit,
                                          color: Colors.white),
                                    ),
                                    // IconButton(
                                    //   onPressed: () {},
                                    //   icon: const Icon(Icons.book_outlined, color: Colors.white),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
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
