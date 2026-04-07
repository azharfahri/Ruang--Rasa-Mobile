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
        title: Text("Detail Pesanan #${order.id}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Info Status
          _buildInfoTile(
            "Status Pembayaran",
            order.paymentStatus?.toUpperCase() ?? "PENDING",
          ),
          const SizedBox(height: 20),

          const Text(
            "Produk Dipesan",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // List Produk
          ...?order.items
              ?.map(
                (item) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    // Diubah jadi Column agar bisa menampung varian di bawahnya
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "x${item.quantity}",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Rp ${NumberFormat('#,###').format(item.subtotal ?? 0)}",
                            style: const TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      // ===============================
                      // BAGIAN VARIAN (LOOPING DETAILS)
                      // ===============================
                      if (item.details != null && item.details!.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(color: Colors.white10, thickness: 1),
                        ),
                        ...item.details!
                            .map(
                              (detail) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.add_circle_outline,
                                      size: 12,
                                      color: accentColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      // Pastikan detail.variantOption?.name sudah sesuai modelmu
                                      detail.optionName ??
                                          "Pilihan Varian",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ],
                  ),
                ),
              )
              .toList(),

          const Divider(color: Colors.white10, height: 40),

          // Ringkasan Pembayaran
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Bayar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Rp ${NumberFormat('#,###').format(order.total ?? 0)}",
                style: const TextStyle(
                  color: accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
