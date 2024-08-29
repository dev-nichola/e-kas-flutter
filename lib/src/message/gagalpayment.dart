import 'package:e_kas/src/shared/warga/navbar_widget.dart';
import 'package:e_kas/src/shared/warga/topbar_widget.dart';
import 'package:flutter/material.dart';

class PaymentFailedPage extends StatefulWidget {
  const PaymentFailedPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentFailedPageState createState() => _PaymentFailedPageState();
}

class _PaymentFailedPageState extends State<PaymentFailedPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Topbar(title: 'Sinoman'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PEMBAYARAN GAGAL',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Terimakasih telah melakukan pembayaran',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to the main page
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B4B5),
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                child: const Text('Kembali ke Halaman Utama'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
