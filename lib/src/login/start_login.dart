import 'package:flutter/material.dart';
import 'package:e_kas/src/login/form_login.dart'; 

class StartLoginPage extends StatelessWidget {
  const StartLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
     
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              // Logo
              Image.asset(
                'assets/image/logos.png', 
                height: 200,
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Keuangan Warga, Aman dan Transparan",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B4B5), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), 
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormLoginPage()),
                  );
                },
                child: const Text(
                  'Masuk',
                  style: TextStyle(color: Colors.white), 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
