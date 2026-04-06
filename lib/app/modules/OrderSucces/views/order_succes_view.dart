import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  static const bgColor = Color(0xFF004643);
  static const cardColor = Color(0xFF001E1D);
  static const accentColor = Color(0xFFF9BC60);

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),

              // 🔥 ICON SUCCESS
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
                child: const Icon(
                  Icons.check,
                  size: 50,
                  color: bgColor,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Pesanan Berhasil 🎉",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Pesanan kamu lagi diproses yaa ☕",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 30),

              // 🔥 DETAIL ORDER
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _row("Order ID", "#${order['id']}"),
                    _row("Nama", order['customer_name']),
                    _row(
                      "Total",
                      "Rp ${NumberFormat('#,###').format(order['total'])}",
                    ),
                    _row("Status", order['status']),
                  ],
                ),
              ),

              const Spacer(),

              // 🔥 BUTTON HOME
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: bgColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Kembali ke Beranda",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 🔥 BUTTON HISTORY
              TextButton(
                onPressed: () {
                  Get.toNamed('/order-history');
                },
                child: const Text(
                  "Lihat Pesanan",
                  style: TextStyle(color: accentColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}