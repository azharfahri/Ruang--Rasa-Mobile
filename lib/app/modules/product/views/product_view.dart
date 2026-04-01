import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/product_controller.dart';
import 'package:ruang_rasa_mobile/app/modules/home/views/home_view.dart';
import 'package:ruang_rasa_mobile/app/routes/app_pages.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});

  static const Color bgColor = Color(0xFF004643);
  static const Color accentColor = Color(0xFFF9BC60);
  static const Color textColor = Color(0xFFFFFFFE);
  static const Color secondaryTextColor = Color(0xFFABD1C6);
  static const Color cardColor = Color(0xFF001E1D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: accentColor),
          );
        }

        if (controller.allProductsWithCategories.isEmpty) {
          return const Center(
            child: Text(
              "Produk tidak tersedia",
              style: TextStyle(color: textColor),
            ),
          );
        }

        return Stack(
          children: [
            CustomScrollView(
              controller: controller.scrollController, // ✅ FIX SCROLL
              slivers: [
                _buildBranchHeader(context),
                _buildStickyCategoryTabs(),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final group =
                          controller.allProductsWithCategories[index];
                      return _buildCategoryGroup(group);
                    },
                    childCount:
                        controller.allProductsWithCategories.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
            Positioned(bottom: 20, left: 16, right: 16, child: CartBar()),
          ],
        );
      }),
    );
  }

  Widget _buildBranchHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: bgColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: InkWell(
        onTap: () => _showBranchPicker(context),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: accentColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            controller.selectedBranchData['name'] ??
                                "Pilih Cabang",
                            style: const TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: textColor,
                            size: 18,
                          ),
                        ],
                      ),
                      Text(
                        controller.selectedBranchData['address'] ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: secondaryTextColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyCategoryTabs() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 60.0,
        child: Container(
          color: bgColor,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: controller.allProductsWithCategories.length,
            itemBuilder: (context, index) {
              final group =
                  controller.allProductsWithCategories[index];
              final catName = group['category']['name'];

              return Obx(() {
                bool isSelected =
                    controller.selectedCategorySlug.value == catName;

                return GestureDetector(
                  onTap: () {
                    controller.selectedCategorySlug.value = catName;
                    controller.scrollToCategory(catName); // ✅ FIX SCROLL
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? accentColor : cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: accentColor.withOpacity(0.3)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      catName,
                      style: TextStyle(
                        color: isSelected ? bgColor : textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGroup(Map<String, dynamic> group) {
    List products = group['products'];
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            group['category']['name'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) =>
              _buildProductCard(products[index]),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        try {
          Get.toNamed(Routes.DETAIL_PRODUK, arguments: item);
        } catch (e) {
          Get.snackbar("Error", "Gagal membuka detail produk");
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: item['image'] ?? "",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image,
                    color: secondaryTextColor,
                    size: 40,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Rp ${NumberFormat('#,###').format(item['price'] ?? 0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBranchPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: secondaryTextColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Pilih Cabang",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 15),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.branchList.length,
                itemBuilder: (context, index) {
                  final branch = controller.branchList[index];
                  return ListTile(
                    leading:
                        const Icon(Icons.storefront, color: accentColor),
                    title: Text(
                      branch['name'],
                      style: const TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      branch['address'],
                      style: const TextStyle(color: secondaryTextColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => controller.changeBranch(branch),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight, maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      SizedBox.expand(child: child);

  @override
  bool shouldRebuild(_SliverAppBarDelegate old) =>
      maxHeight != old.maxHeight ||
      minHeight != old.minHeight ||
      child != old.child;
}