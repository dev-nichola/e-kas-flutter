import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import '../src/login/start_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await dotenv.load(fileName: ".env"); // Load environment variables

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LottieDemoApp(),
  ));
}

class LottieDemoApp extends StatefulWidget {
  const LottieDemoApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LottieDemoAppState createState() => _LottieDemoAppState();
}

class _LottieDemoAppState extends State<LottieDemoApp> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const StartLoginPage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Customize AppBar if needed
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Lottie.asset('assets/animations/lottie_animation.json'),
          ),
        ),
      ),
    );
  }
}
