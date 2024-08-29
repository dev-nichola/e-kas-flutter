import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_kas/service/warga/tagihan/models/tagihan_model.dart';

class InvoicePage extends StatelessWidget {
  final double totalTagihan;
  final List<Tagihan> selectedTagihan;

  const InvoicePage({
    super.key,
    required this.totalTagihan,
    required this.selectedTagihan, required List<dynamic> paymentDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Tagihan: Rp ${NumberFormat('#,##0', 'id_ID').format(totalTagihan)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: selectedTagihan.length,
                itemBuilder: (context, index) {
                  final tagihan = selectedTagihan[index];
                  return ListTile(
                    title: Text('Tagihan ID: ${tagihan.tagihanId}'),
                    subtitle: Text('Nominal: Rp ${NumberFormat('#,##0', 'id_ID').format(tagihan.totalTagihan)}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
