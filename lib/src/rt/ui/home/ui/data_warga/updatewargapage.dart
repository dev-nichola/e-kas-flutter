// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:e_kas/src/rt/ui/home/ui/data_warga/datawargapage.dart';
import 'package:flutter/material.dart';
import 'package:e_kas/service/rt/datawarga_service.dart';
import 'package:flutter/services.dart';
import '../../../../../shared/rt/navbar_widget.dart';
import 'package:e_kas/src/shared/rt/topbar_widget.dart';

class UpdateWargaPage extends StatefulWidget {
  final String wargaId;

  const UpdateWargaPage({super.key, required this.wargaId});

  @override
  _UpdateWargaPageState createState() => _UpdateWargaPageState();
}

class _UpdateWargaPageState extends State<UpdateWargaPage> {
  int _currentIndex = 0;
  bool _isLoading = false;

  final _namaLengkapController = TextEditingController();
  final _nikController = TextEditingController();
  final _alamatLengkapController = TextEditingController();
  final _nomorWhatsAppController = TextEditingController();

  DateTime? _tanggalLahir;
  String _pekerjaan = 'Pegawai_Swasta';
  String _jenisKelamin = 'Laki_Laki';
  String _agama = 'Islam';
  String _status = 'Menikah';
  String _role = 'RT';

  @override
  void initState() {
    super.initState();
    _loadWargaData();
  }

  Future<void> _loadWargaData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = GetWargaByIdService();
      final data = await service.getWargaById(widget.wargaId);

      if (data != null) {
        setState(() {
          _namaLengkapController.text = data['nama_Lengkap'] ?? '';
          _nikController.text = data['nomor_Ktp'] ?? '';
          _alamatLengkapController.text = data['alamat_Lengkap'] ?? '';
          _nomorWhatsAppController.text = data['nomor_whatsapp'] ?? '';
          _tanggalLahir = DateTime.parse(
              data['tanggal_Lahir'] ?? DateTime.now().toString());
          _pekerjaan = data['pekerjaan'] ?? 'Pegawai_Swasta';
          _jenisKelamin = data['jenis_kelamin'] ?? 'Laki_Laki';
          _agama = data['agama'] ?? 'Islam';
          _status = data['status'] ?? 'Menikah';
          _role = data['role'] ?? 'RT';
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
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
      builder: (context) {
        return AlertDialog(
          title: const Text('Sukses'),
          content: const Text('Data warga berhasil diupdate.'),
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

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    if (_tanggalLahir == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final updatedData = {
        'nama_Lengkap': _namaLengkapController.text,
        'tanggal_Lahir': _tanggalLahir!.toIso8601String(),
        'nomor_Ktp': _nikController
            .text, // Ensure this is the correct field name for the API
        'alamat_Lengkap': _alamatLengkapController.text,
        'jenis_kelamin':
            _jenisKelamin, // Ensure this field name matches the API
        'agama': _agama,
        'pekerjaan': _pekerjaan,
        'status': _status,
        'nomor_whatsapp': _nomorWhatsAppController
            .text, // Ensure this field name matches the API

        'role': _role,
      };

      final service = UpdateWargaService();
      final success = await service.updateWarga(widget.wargaId, updatedData);

      if (success) {
        await _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui data warga')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat memperbarui data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _nikController.dispose();
    _alamatLengkapController.dispose();
    _nomorWhatsAppController.dispose();

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
          value: items.contains(value)
              ? value
              : null, // Ensure the value is in the items list
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
          child: Column(
            children: [
              const Topbar(title: 'EDIT WARGA'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField(
                      label: 'Nama Lengkap',
                      controller: _namaLengkapController,
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
                      inputFormatters: [LengthLimitingTextInputFormatter(16)],
                    ),
                    _buildTextField(
                      label: 'Alamat Lengkap',
                      controller: _alamatLengkapController,
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
                        'Kristen_Protestan',
                        'Kristen_Katolik',
                        'Budha',
                        'Khong_hu_ciu',
                        'Hindu'
                      ],
                      onChanged: (value) => setState(() => _agama = value!),
                    ),
                    _buildDropdownField(
                      label: 'Pekerjaan',
                      value: _pekerjaan,
                      items: ['Pegawai_Swasta', 'Pegawai_Negeri', 'Mahasiswa'],
                      onChanged: (value) => setState(() => _pekerjaan = value!),
                    ),
                    _buildDropdownField(
                      label: 'Status',
                      value: _status,
                      items: ['Menikah', 'Belum Menikah', 'Duda', 'Janda'],
                      onChanged: (value) => setState(() => _status = value!),
                    ),
                    _buildTextField(
                      label: 'Nomor WhatsApp',
                      controller: _nomorWhatsAppController,
                    ),
                    _buildDropdownField(
                      label: 'Role',
                      value: _role,
                      items: ['RT', 'Warga', 'Bendahara'],
                      onChanged: (value) => setState(() => _role = value!),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Edit'),
                        ),
                      ],
                    ),
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
}
