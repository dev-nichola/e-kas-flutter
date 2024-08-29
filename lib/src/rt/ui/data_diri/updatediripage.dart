// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_kas/service/rt/datadiri_service.dart';
import 'package:e_kas/src/rt/ui/data_diri/data_diri_page.dart';
import '../../../shared/rt/navbar_widget.dart';
import '../../../shared/rt/topbar_widget.dart';

class UpdateDiriPage extends StatefulWidget {
  final String diriId;
  final Map<String, dynamic>? initialData;

  const UpdateDiriPage({
    super.key,
    required this.diriId,
    this.initialData,
  });

  @override
  _UpdateDiriPageState createState() => _UpdateDiriPageState();
}

class _UpdateDiriPageState extends State<UpdateDiriPage> {
  int _currentIndex = 5;
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
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.initialData != null) {
      setState(() {
        _namaLengkapController.text = widget.initialData!['nama_Lengkap'] ?? '';
        _nikController.text = widget.initialData!['nomor_Ktp'] ?? '';
        _alamatLengkapController.text = widget.initialData!['alamat_Lengkap'] ?? '';
        _nomorWhatsAppController.text = widget.initialData!['nomor_whatsapp'] ?? '';
        _tanggalLahir = DateTime.parse(widget.initialData!['tanggal_Lahir'] ?? DateTime.now().toString());
        _pekerjaan = widget.initialData!['pekerjaan'] ?? 'Pegawai_Swasta';
        _jenisKelamin = widget.initialData!['jenis_kelamin'] ?? 'Laki_Laki';
        _agama = widget.initialData!['agama'] ?? 'Islam';
        _status = widget.initialData!['status'] ?? 'Menikah';
      });
    }
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _tanggalLahir) {
      setState(() {
        _tanggalLahir = picked;
      });
    }
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Data updated successfully'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DataDiriPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

 Future<void> _updateData() async {
  // Prepare the data to be updated
  final updatedData = {
    'nomor_whatsapp': _nomorWhatsAppController.text,
    'password': _passwordController.text,
  };

  try {
    setState(() {
      _isLoading = true;
    });
    // Call the update function
    await updateUserData(updatedData);
    // Show success dialog if update is successful
    _showSuccessDialog();
  } catch (e) {
    // Print the error for debugging
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(title: 'Update Data Diri'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildTextField(
                              label: 'Nama Lengkap',
                              controller: _namaLengkapController,
                              readOnly: true,
                            ),
                            _buildTextField(
                              label: 'Tanggal Lahir',
                              controller: TextEditingController(
                                text: _tanggalLahir == null
                                    ? ''
                                    : "${_tanggalLahir!.year}-${_tanggalLahir!.month.toString().padLeft(2, '0')}-${_tanggalLahir!.day.toString().padLeft(2, '0')}",
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context),
                            ),
                            _buildTextField(
                              label: 'Nomor Identitas Kependudukan (NIK)',
                              controller: _nikController,
                              readOnly: true,
                              inputFormatters: [LengthLimitingTextInputFormatter(16)],
                            ),
                            _buildTextField(
                              label: 'Alamat Lengkap',
                              controller: _alamatLengkapController,
                              readOnly: true,
                            ),
                            _buildTextField(
                              label: 'Jenis Kelamin',
                              controller: TextEditingController(
                                text: _jenisKelamin,
                              ),
                              readOnly: true,
                            ),
                            _buildTextField(
                              label: 'Agama',
                              controller: TextEditingController(
                                text: _agama,
                              ),
                              readOnly: true,
                            ),
                            _buildTextField(
                              label: 'Pekerjaan',
                              controller: TextEditingController(
                                text: _pekerjaan,
                              ),
                              readOnly: true,
                            ),
                            _buildTextField(
                              label: 'Status',
                              controller: TextEditingController(
                                text: _status,
                              ),
                              readOnly: true,
                            ),
                            _buildTextField(
                              label: 'Nomor WhatsApp',
                              controller: _nomorWhatsAppController,
                            ),
                            _buildTextField(
                              label: 'Password',
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _updateData,
                              child: const Text('Update Data'),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            Navbar(
              currentIndex: _currentIndex,
              onTap: _onNavbarTap,
            ),
          ],
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
