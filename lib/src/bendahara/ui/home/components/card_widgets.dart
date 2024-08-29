import 'package:flutter/material.dart';

// Widget buildCard(String title, IconData? icon, double width) {
//   return SizedBox(
//     height: 90,
//     width: width,
//     child: Card(
//       elevation: 3,
//       color: const Color(0xFF06B4B5),
//       child: InkWell(
//         onTap: () {},
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (icon != null)
//               Icon(
//                 icon,
//                 size: 30,
//                 color: Colors.white,
//               ),
//             if (icon != null)
//               const SizedBox(height: 8),
//             Flexible(
//               child: Text(
//                 title,
//                 style: const TextStyle(fontSize: 12, color: Colors.white),
//                 textAlign: TextAlign.center,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

Widget buildCard(String title, IconData icon, double size) {
  return SizedBox(
    width: 120, // Atur lebar sesuai kebutuhan Anda
    child: Card(
      color: const Color(0xFF06B4B5),
      child: SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: size / 2, color: Colors.white),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}





Widget buildRoundedCard(String title, IconData? icon, double width) {
  return SizedBox(
    height: 50,
    width: width,
    child: Card(
      elevation: 3,
      color: const Color(0xFF06B4B5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(48.0), 
      ),
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 30,
                color: Colors.white,
              ),
            if (icon != null)
              const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
