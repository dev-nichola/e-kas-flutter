import 'package:flutter/material.dart';
import '../rt/ui/home/rthomepage.dart';
import '../bendahara/ui/home/bendaharahomepage.dart';
import '../warga/ui/home/wargahomepage.dart';
import 'package:e_kas/service/login_service.dart';

class FormLoginPage extends StatefulWidget {
  const FormLoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FormLoginPageState createState() => _FormLoginPageState();
}

class _FormLoginPageState extends State<FormLoginPage> {
  bool _obscureText = true;
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _nikError; // Variable to store NIK error message
  String? _passwordError; // Variable to store Password error message

  @override
  void dispose() {
    _nikController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showLoadingDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _nikError = null; // Reset the error message
      _passwordError = null; // Reset the error message
    });

    if (_nikController.text.isEmpty) {
      setState(() {
        _nikError = 'NIK wajib diisi';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password wajib diisi';
      });
      return;
    }

    _showLoadingDialog(); // Show loading dialog

    final result = await LoginService.login(
      _nikController.text,
      _passwordController.text,
    );

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(); // Hide loading dialog

    if (result != null && result.containsKey('token')) {
      final String? role = result['role']?.toString();

      if (role != null && (role == 'RT')) {
        Widget nextPage = const RtHomePage(); 

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      } else if (role != null && (role == 'Warga')) {
        Widget nextPage = const WargaHomePage(); 

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      } else if (role != null && (role == 'Bendahara')) {
        Widget nextPage = const BendaharaHomePage(); 

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      } else {
        _showErrorDialog('Invalid role received: $role');
      }
    } else {
      setState(() {
        if (result != null && result.containsKey('error')) {
          final String error = result['error'];
          if (error == 'NIK yang anda masukkan tidak terdaftar') {
            _nikError = error;
          } else if (error == 'Kata sandi salah') {
            _passwordError = error;
          } else {
            _showErrorDialog('Login failed: $error');
          }
        } else {
          _showErrorDialog('Login failed with unknown error.');
        }
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/image/logos.png',
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              // Nomor Identitas Kependudukan (NIK)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nomor Identitas Kependudukan (NIK)',
                    style: TextStyle(
                      color: Color(0xFF06B4B5),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _nikController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  if (_nikError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            _nikError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Password
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
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFF06B4B5),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  if (_passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            _passwordError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              // Tombol Login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF154D4D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: _login,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
