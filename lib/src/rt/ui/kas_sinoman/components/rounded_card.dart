import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double width;
  final Color background;
  final TextStyle style; // Tambahkan parameter style

  const RoundedCard({
    required this.title,
    this.icon,
    required this.width,
    this.background = const Color(0xFF06B4B5),
    this.style = const TextStyle(fontSize: 15, color: Colors.white), // Default style
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: style, // Gunakan parameter style
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
