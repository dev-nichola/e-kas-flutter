import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  final String title;
  final bool isBackButtonEnabled;

  const Topbar({
    super.key, 
    required this.title, 
    this.isBackButtonEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isBackButtonEnabled && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        color: const Color(0xFF06B4B5),
        height: 50.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: Row(
            children: [
              if (isBackButtonEnabled && Navigator.canPop(context))
                const Icon(Icons.arrow_back, color: Colors.white),
              if (isBackButtonEnabled && Navigator.canPop(context))
                const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
