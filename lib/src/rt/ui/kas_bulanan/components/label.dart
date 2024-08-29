import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String title;
  final double width;

  const Label({
    required this.title,
    required this.width,
    super.key, required TextStyle style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
