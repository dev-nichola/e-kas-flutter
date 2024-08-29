import 'package:flutter/material.dart';

Widget buildKeteranganCard(String title, IconData? icon, double width) {
  String description = '';
  if (title == 'Kas Sinom') {
    description = 'Kas Sinom adalah dana kas yang biasanya dikaitkan dengan kegiatan atau tradisi tertentu, khususnya yang bersifat lokal atau komunitas. Nama "Sinom" mungkin mengacu pada suatu tradisi atau kebiasaan khusus dalam komunitas Anda. Dana ini biasanya digunakan untuk keperluan khusus yang terkait dengan kegiatan atau acara tersebut.';
  } else if (title == 'Kas Agustusan') {
    description = 'Kas Agustusan adalah dana kas yang dikhususkan untuk kegiatan yang berhubungan dengan perayaan Hari Kemerdekaan Indonesia pada bulan Agustus. Dana ini digunakan untuk mendukung berbagai acara dan kegiatan yang diadakan dalam rangka memperingati Hari Kemerdekaan.';
  }else if (title == 'Kas Bulanan') {
    description = 'Kas bulanan adalah dana kas yang dikelola setiap bulan untuk mendukung kegiatan dan kebutuhan operasional di tingkat kampung atau desa. Dana ini digunakan untuk berbagai keperluan, seperti penyelenggaraan acara kampung, perawatan fasilitas umum dengan adanya Kas Bulanan Kampung, pengelolaan keuangan di tingkat kampung dapat lebih terencana dan teratur, memastikan bahwa kebutuhan kampung dapat terpenuhi dengan baik dan kegiatan kampung berjalan lancar.';
  }

  

  return SizedBox(
    height: 90,
    width: width,
    child: Card(
      elevation: 3,
      color: const Color(0xFFE4E2DF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
      ),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 40,
                  color: const Color(0xFFD8AF5C),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 7, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
