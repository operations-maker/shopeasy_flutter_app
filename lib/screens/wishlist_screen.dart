import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/shop_provider.dart';
import '../utils/theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/product_card.dart';
import '../widgets/tap_scale_effect.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    
    // Get all products that are wishlisted
    final favProducts = shopProvider.products
        .where((p) => shopProvider.isWishlisted(p.id))
        .toList();

    return Scaffold(
      backgroundColor: ShopEasyTheme.background,
      appBar: AppBar(
        title: const Text('MY WISHLIST'),
      ),
      body: SafeArea(
        bottom: false,
        child: favProducts.isEmpty
            ? _buildEmptyWishlist(context)
            : GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // extra bottom padding for floating bottom nav
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                itemCount: favProducts.length,
                itemBuilder: (context, index) {
                  final product = favProducts[index];
                  return ProductCard(product: product);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glass box icon
          GlassContainer(
            height: 90,
            width: 90,
            borderRadius: 30,
            border: Border.all(color: ShopEasyTheme.glassBorder, width: 0.8),
            child: const Icon(
              Icons.favorite_outline_rounded,
              size: 40,
              color: ShopEasyTheme.goldAccent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your wishlist is empty',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Save your favorite luxury items here.',
            style: GoogleFonts.poppins(
              color: ShopEasyTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 28),
          TapScaleEffect(
            onTap: () {
              // Action, can pop or navigate to shop
            },
            child: ElevatedButton(
              onPressed: () {
                // Navigate
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text('DISCOVER ITEMS'),
            ),
          ),
        ],
      ),
    );
  }
}
