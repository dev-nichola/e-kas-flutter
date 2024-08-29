import 'package:flutter/material.dart';

class MonthCard extends StatelessWidget {
  final String title;
  final double width;
  final Color background;

  const MonthCard({
    required this.title,
    required this.width,
    this.background = const Color(0xFFE4E2DF),
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
            style: const TextStyle(fontSize: 15, color: Colors.black),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
