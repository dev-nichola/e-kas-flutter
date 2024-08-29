// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:e_kas/src/rt/ui/home/ui/data_warga/datawargapage.dart';
import 'package:flutter/material.dart';
import 'package:e_kas/service/rt/datawarga_service.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/rt/navbar_widget.dart';
import 'package:e_kas/src/shared/rt/topbar_widget.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  _TambahWargaPageState createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  int _currentIndex = 0;
  bool _isLoading = false;

  final _namaLengkapController = TextEditingController();
  final _nikController = TextEditingController();
  final _alamatLengkapController = TextEditingController();
  final _nomorWhatsAppController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _tanggalLahir;
  String _pekerjaan = 'Pegawai_Swasta';
  String _jenisKelamin = 'Laki_Laki';
  String _agama = 'Islam';
  String _status = 'Menikah';
  String _role = 'Warga';
  bool _passwordVisible = false;

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  void _generatePassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789()_+~`|}{[]:;?><,./-=';
    String password = '';
    final random = Random();

    for (int i = 0; i < 8; i++) {
      final randomIndex = random.nextInt(chars.length);
      password += chars[randomIndex];
    }

    setState(() {
      _passwordController.text = password;
    });
  }

  void _submit() {
    if (_namaLengkapController.text.isEmpty ||
        _nikController.text.isEmpty ||
        _alamatLengkapController.text.isEmpty ||
        _nomorWhatsAppController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _tanggalLahir == null) {
      _showRequiredFieldDialog(); // Tampilkan pop-up jika ada data yang belum diisi
      return;
    }

    setState(() {
      _isLoading = true;
    });

    TambahWargaService()
        .tambahWarga(
      namaLengkap: _namaLengkapController.text,
      tanggalLahir: _tanggalLahir!,
      nomorKtp: _nikController.text,
      pekerjaan: _pekerjaan,
      alamatLengkap: _alamatLengkapController.text,
      jenisKelamin: _jenisKelamin,
      agama: _agama,
      status: _status,
      nomorWhatsApp: _nomorWhatsAppController.text,
      role: _role,
      password: _passwordController.text,
    )
        .then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSuccessDialog();
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        if (e.toString().contains('NIK sudah terdaftar')) {
          _showNikExistsDialog();
        } else if (e.toString().contains('Nomor WhatsApp sudah terdaftar')) {
          _showWaExistsDialog();
        } else {
          _showErrorDialog(e.toString());
        }
      }
    });
  }

  Future<void> _showRequiredFieldDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('WARNING!'),
          content: const Text('Semua data wajib diisi.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sukses'),
          content: const Text('Data warga berhasil ditambahkan.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DataWargaPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNikExistsDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('WARNING!'),
          content: const Text('NIK sudah terdaftar.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showWaExistsDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('WARNING!'),
          content: const Text('Nomor WhatsApp sudah terdaftar.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ERROR!'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _nikController.dispose();
    _alamatLengkapController.dispose();
    _nomorWhatsAppController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    bool obscureText = false,
    Widget? suffixIcon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF06B4B5),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            suffixIcon: suffixIcon,
          ),
          style: const TextStyle(
            color: Color(0xFF06B4B5),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF06B4B5),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          style: const TextStyle(
            color: Color(0xFF06B4B5),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  const Topbar(title: 'Tambah Warga'),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          label: 'Nama Lengkap',
                          controller: _namaLengkapController,
                        ),
                        _buildTextField(
                          label: 'NIK',
                          controller: _nikController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                          ],
                        ),
                        _buildTextField(
                          label: 'Alamat Lengkap',
                          controller: _alamatLengkapController,
                        ),
                        _buildTextField(
                          label: 'Nomor WhatsApp',
                          controller: _nomorWhatsAppController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        _buildTextField(
                          label: 'Tanggal Lahir',
                          controller: TextEditingController(
                              text: _tanggalLahir != null
                                  ? "${_tanggalLahir!.day}/${_tanggalLahir!.month}/${_tanggalLahir!.year}"
                                  : ''),
                          readOnly: true,
                          onTap: () => _selectDate(context),
                        ),
                        _buildDropdownField(
                          label: 'Pekerjaan',
                          value: _pekerjaan,
                          items: [
                            'Pegawai_Swasta',
                            'Pegawai_Negeri',
                            'Wiraswasta',
                            'Lainnya'
                          ],
                          onChanged: (value) =>
                              setState(() => _pekerjaan = value!),
                        ),
                        _buildDropdownField(
                          label: 'Jenis Kelamin',
                          value: _jenisKelamin,
                          items: ['Laki_Laki', 'Perempuan'],
                          onChanged: (value) =>
                              setState(() => _jenisKelamin = value!),
                        ),
                        _buildDropdownField(
                          label: 'Agama',
                          value: _agama,
                          items: [
                            'Islam',
                            'Kristen',
                            'Katolik',
                            'Hindu',
                            'Buddha',
                            'Konghucu'
                          ],
                          onChanged: (value) => setState(() => _agama = value!),
                        ),
                        _buildDropdownField(
                          label: 'Status',
                          value: _status,
                          items: [
                            'Menikah',
                            'Belum_Menikah',
                            'Duda',
                            'Janda'
                          ],
                          onChanged: (value) => setState(() => _status = value!),
                        ),
                        Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Password',
                          style: TextStyle(
                            color: Color(0xFF06B4B5),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF06B4B5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            ElevatedButton(
                              onPressed: _generatePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD8AF5C),
                              ),
                              child: const Text('Generate Password'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                        _buildDropdownField(
                          label: 'Role',
                          value: _role,
                          items: ['Warga', 'RT', 'Bendahara'],
                          onChanged: (value) => setState(() => _role = value!),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF06B4B5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text(
                                  'Tambah Warga',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
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
}
