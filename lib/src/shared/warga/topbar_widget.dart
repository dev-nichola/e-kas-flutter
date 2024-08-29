import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  final String title;

  const Topbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ignore: avoid_print
        print('Title tapped');
      },
      child: Container(
        color: const Color(0xFF06B4B5),
        height: 50.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
