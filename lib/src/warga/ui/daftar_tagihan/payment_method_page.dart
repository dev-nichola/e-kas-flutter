import 'dart:async';
import 'dart:convert';
import 'package:e_kas/service/warga/tagihan/models/payment_method_model.dart';
import 'package:e_kas/src/warga/ui/daftar_tagihan/daftar_tagihan_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../service/warga/tagihan/models/tagihan_model.dart';
import '../../../../service/warga/tagihan/cekstatus_service.dart';
import '../../../../service/warga/tagihan/payment_method_service.dart';
import '../../../shared/warga/navbar_widget.dart';
import '../../../shared/warga/topbar_widget.dart';


class PaymentMethodPage extends StatefulWidget {
  final double totalTagihan;
  final List<Tagihan> selectedTagihan;

  const PaymentMethodPage({
    Key? key,
    required this.totalTagihan,
    required this.selectedTagihan,
  }) : super(key: key);

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int _currentIndex = 4;
  late Future<List<PaymentMethod>> _paymentMethodsFuture;
  PaymentMethod? _selectedPaymentMethod;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _paymentMethodsFuture = PaymentMethodService.fetchPaymentMethods();
  }

  void _onNavbarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onPaymentMethodSelected(PaymentMethod paymentMethod) {
    setState(() {
      _selectedPaymentMethod = paymentMethod;
    });
  }

  Future<void> _makePayment() async {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await PaymentMethodService.sendPaymentRequest(
        totalTagihan: widget.totalTagihan,
        selectedTagihan: widget.selectedTagihan,
        paymentMethodCode: _selectedPaymentMethod!.code,
      );

      if (response.isNotEmpty) {
        final String checkoutUrl = response.first['detailPembayaran']['checkoutUrl'];
        final String idTagihan = response.first['detailPembayaran']['id'];

        if (mounted) {
          // Tampilkan popup dengan detail respons dan mulai cek status pembayaran
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => PaymentStatusDialog(
              idTagihan: idTagihan,
              checkoutUrl: checkoutUrl,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Topbar(title: 'Metode Pembayaran'),
            Expanded(
              child: FutureBuilder<List<PaymentMethod>>(
                future: _paymentMethodsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada metode pembayaran tersedia'));
                  } else {
                    final paymentMethods = snapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: paymentMethods.length,
                        itemBuilder: (context, index) {
                          final paymentMethod = paymentMethods[index];
                          return ListTile(
                            leading: Image.network(
                              paymentMethod.iconUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                            title: Text(paymentMethod.name),
                            trailing: _selectedPaymentMethod == paymentMethod
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                            onTap: () => _onPaymentMethodSelected(paymentMethod),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _makePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B4B5),
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                child: Text(
                  'Total yang harus dibayarkan: Rp ${NumberFormat('#,##0', 'id_ID').format(widget.totalTagihan)}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _currentIndex,
        onTap: _onNavbarTap,
      ),
    );
  }
}

class PaymentStatusDialog extends StatefulWidget {
  final String idTagihan;
  final String checkoutUrl;

  const PaymentStatusDialog({
    Key? key,
    required this.idTagihan,
    required this.checkoutUrl,
  }) : super(key: key);

  @override
  _PaymentStatusDialogState createState() => _PaymentStatusDialogState();
}

class _PaymentStatusDialogState extends State<PaymentStatusDialog> {
  late Timer _timer;
  bool _paymentSuccess = false;
  bool _redirected = false;
  bool _paymentFailed = false; // Track if payment failed
  int _secondsRemaining = 60; // 1 menit

  @override
  void initState() {
    super.initState();
    _startPaymentCheck();
  }

  void _startPaymentCheck() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final status = await StatusService.fetchStatus(widget.idTagihan);
      
      // Log status untuk debugging
      print('Status pembayaran: ${status?.status}');

      if (status != null && status.status == "SUCCESS") {
        setState(() {
          _paymentSuccess = true;
        });
        _timer.cancel();

        // Redirect setelah pembayaran berhasil
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pop(); // Tutup dialog
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const WargaTagihanPage(),
              ),
            );
          }
        });
      } else {
        setState(() {
          _secondsRemaining -= 5;
        });

        if (_secondsRemaining <= 0) {
          _timer.cancel();
          setState(() {
            _paymentFailed = true;
          });
          // Tutup dialog jika timeout
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).pop(); // Tutup dialog
            }
          });
        }
      }
    });

    // Redirect ke halaman pembayaran setelah 5 detik
    Future.delayed(const Duration(seconds: 5), () async {
      if (mounted && !_redirected) {
        setState(() {
          _redirected = true;
        });
        await _redirectToPayment();
      }
    });
  }

  Future<void> _redirectToPayment() async {
    if (await canLaunch(widget.checkoutUrl)) {
      await launch(widget.checkoutUrl);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka URL: ${widget.checkoutUrl}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_paymentFailed ? 'Pembayaran Gagal' : 'Menunggu Pembayaran'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_paymentFailed)
            const Text('Maaf pembayaran gagal, karena waktu habis.'),
          if (!_paymentFailed && !_paymentSuccess)
            const Text('Silakan selesaikan pembayaran Anda.'),
          if (_paymentSuccess)
            const Text('Pembayaran berhasil!'),
          const SizedBox(height: 16),
          if (!_paymentFailed && !_paymentSuccess)
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          if (!_paymentFailed && !_paymentSuccess)
            const SizedBox(height: 16),
          if (!_paymentFailed && !_paymentSuccess)
            Text(
              'Redirecting in $_secondsRemaining seconds...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
        ],
      ),
      actions: [
        if (_paymentFailed) 
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('OK'),
          ),
      ],
    );
  }
}
