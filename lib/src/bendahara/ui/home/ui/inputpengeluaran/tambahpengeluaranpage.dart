// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:e_kas/src/bendahara/ui/home/ui/inputpengeluaran/inputpengeluaranpage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:e_kas/service/bendahara/input_pengeluaran_service.dart';
import '../../../../../shared/bendahara/navbar_widget.dart';
import '../../../../../shared/bendahara/topbar_widget.dart';

class TambahPengeluaranPage extends StatefulWidget {
  const TambahPengeluaranPage({super.key});

  @override
  _TambahPengeluaranPageState createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 0;
  String? _selectedCategory;
  DateTime? _selectedDate;
  String _fileName = '';
  String _filePath = ''; // Path file yang sebenarnya
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    final nominal = double.tryParse(_nominalController.text);
    if (nominal == null || nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal harus berupa angka positif')),
      );
      return;
    }

    final payload = {
      "nama": _nameController.text,
      "kategoriKas": _selectedCategory,
      "nominal": nominal, // Gunakan tipe data double
      "tanggalPengeluaran": _selectedDate?.toIso8601String(),
      "buktiPengeluaran": _filePath, // Kirim path file
    };

    try {
      await submitPengeluaran(payload);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengeluaran berhasil disimpan')),
      );
      
      // Redirect ke halaman InputPengeluaranPage dan refresh data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InputPengeluaranPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan pengeluaran: $e')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Topbar(title: 'INPUT PENGELUARAN KAS'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildTextField('Nama', controller: _nameController),
                        _buildDropdownField('Kategori Kas'),
                        _buildDateField('Tanggal'),
                        _buildTextField(
                          'Nominal Pengeluaran', 
                          controller: _nominalController, 
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harap masukkan nominal';
                            }
                            final nominal = double.tryParse(value);
                            if (nominal == null || nominal <= 0) {
                              return 'Nominal harus berupa angka positif';
                            }
                            return null;
                          }
                        ),
                        _buildFilePicker('Bukti Pengeluaran Kas (opsional)'),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF154D4D),
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Simpan'),
                        ),
                      ],
                    ),
                  ),
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

  Widget _buildTextField(String label, {TextEditingController? controller, TextInputType keyboardType = TextInputType.text, FormFieldValidator<String>? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF06B4B5)), // Label color
          ),
          const SizedBox(height: 4.0),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            validator: validator ?? (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF06B4B5)), // Label color
          ),
          const SizedBox(height: 4.0),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Sinoman', child: Text('Sinoman')),
              DropdownMenuItem(value: 'Agustusan', child: Text('Agustusan')),
              DropdownMenuItem(value: 'Bulanan', child: Text('Bulanan')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF06B4B5)), // Label color
          ),
          const SizedBox(height: 4.0),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            controller: TextEditingController(
              text: _selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                  : '',
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilePicker(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF06B4B5)), // Label color
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  controller: TextEditingController(text: _fileName),
                ),
              ),
              const SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    setState(() {
                      _fileName = result.files.single.name;
                      _filePath = result.files.single.path ?? ''; // Simpan path file
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF154D4D),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Pilih'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
