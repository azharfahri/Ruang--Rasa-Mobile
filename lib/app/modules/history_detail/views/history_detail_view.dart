import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/history_detail_controller.dart';

class HistoryDetailView extends GetView<HistoryDetailController> {
  const HistoryDetailView({super.key});

  static const Color bgColor = Color(0xFF004643);
  static const Color cardColor = Color(0xFF001E1D);
  static const Color accentColor = Color(0xFFF9BC60);

  @override
  Widget build(BuildContext context) {
    final order = controller.order;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Detail Pesanan #${order.id}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // 1. TIKET KODE PENGAMBILAN
          if (order.pickupCode != null && order.pickupCode!.isNotEmpty) ...[
            _buildPickupTicket(order.pickupCode!),
            const SizedBox(height: 25),
          ],

          // 2. BAGIAN STATUS (DOUBLE TILE)
          Row(
            children: [
              // Status Pesanan (Proses/Siap/Selesai)
              Expanded(
                child: _buildStatusCard(
                  "Status Pesanan",
                  order.status?.toUpperCase() ?? "PENDING",
                  isOrderStatus: true,
                ),
              ),
              const SizedBox(width: 12),
              // Status Pembayaran (Pending/Settlement)
              Expanded(
                child: _buildStatusCard(
                  "Pembayaran",
                  order.paymentStatus?.toUpperCase() ?? "PENDING",
                  isOrderStatus: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // 3. HEADER DAFTAR PRODUK
          Row(
            children: [
              const Icon(Icons.coffee, color: accentColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Produk Dipesan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 4. LIST ITEM PESANAN
          if (order.items != null)
            ...order.items!.map((item) => _buildProductItemCard(item)).toList(),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: Colors.white10, thickness: 1),
          ),

          // 5. RINGKASAN TOTAL
          _buildTotalSection(order.total ?? 0),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Card Status yang lebih modern dan berwarna dinamis
  Widget _buildStatusCard(String title, String value, {required bool isOrderStatus}) {
    // Logika Warna dinamis berdasarkan status
    Color statusColor = accentColor;
    if (value == "READY" || value == "SETTLEMENT" || value == "COMPLETED") {
      statusColor = Colors.greenAccent;
    } else if (value == "PROCESSING" || value == "CONFIRMED") {
      statusColor = Colors.blueAccent;
    } else if (value == "CANCELLED" || value == "EXPIRED") {
      statusColor = Colors.redAccent;
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupTicket(String code) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "KODE PENGAMBILAN",
            style: TextStyle(
              color: cardColor.withOpacity(0.6),
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              code,
              style: const TextStyle(
                color: cardColor,
                fontSize: 52,
                fontWeight: FontWeight.bold,
                letterSpacing: 6,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: List.generate(
                20,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 1.5,
                    color: cardColor.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Tunjukkan ke Barista saat pesanan siap",
            style: TextStyle(
              color: cardColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProductItemCard(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName ?? "Produk",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Jumlah: ${item.quantity}",
                      style: const TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                "Rp ${NumberFormat('#,###').format(item.subtotal ?? 0)}",
                style: const TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (item.details != null && item.details!.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: Colors.white10, thickness: 1),
            ),
            ...item.details!.map((detail) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 14, color: accentColor),
                  const SizedBox(width: 10),
                  Text(
                    detail.optionName ?? "Pilihan",
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            )).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalSection(int total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "TOTAL BAYAR",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "Rp ${NumberFormat('#,###').format(total)}",
            style: const TextStyle(
              color: accentColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}