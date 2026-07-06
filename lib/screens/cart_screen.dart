import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/shop_provider.dart';
import '../utils/theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/tap_scale_effect.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final cartItems = shopProvider.cartItems;

    return Scaffold(
      backgroundColor: ShopEasyTheme.background,
      appBar: AppBar(
        title: const Text('MY CART'),
      ),
      body: SafeArea(
        bottom: false,
        child: cartItems.isEmpty
            ? _buildEmptyCart(context)
            : Column(
                children: [
                  // Cart items list
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return _buildCartItemTile(context, item, shopProvider);
                      },
                    ),
                  ),

                  // Bottom calculation summary & checkout
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96), // Extra bottom padding for floating bottom nav
                    child: Column(
                      children: [
                        // Price summary card (Glassmorphic)
                        GlassContainer(
                          borderRadius: 20,
                          padding: const EdgeInsets.all(16.0),
                          border: Border.all(
                            color: ShopEasyTheme.glassBorder,
                            width: 0.8,
                          ),
                          child: Column(
                            children: [
                              _buildSummaryRow(
                                  'Subtotal', '\$${shopProvider.cartSubtotal.toStringAsFixed(2)}'),
                              const SizedBox(height: 10),
                              _buildSummaryRow(
                                  'Delivery Fee',
                                  shopProvider.deliveryFee == 0.0
                                      ? 'FREE'
                                      : '\$${shopProvider.deliveryFee.toStringAsFixed(2)}',
                                  isFree: shopProvider.deliveryFee == 0.0),
                              const Divider(height: 24, thickness: 1),
                              _buildSummaryRow(
                                'Total',
                                '\$${shopProvider.cartTotal.toStringAsFixed(2)}',
                                isTotal: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Proceed to Checkout button
                        TapScaleEffect(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CheckoutScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: ShopEasyTheme.goldGradient,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: ShopEasyTheme.goldAccent.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'PROCEED TO CHECKOUT',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ],
                            ),
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

  Widget _buildEmptyCart(BuildContext context) {
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
              Icons.shopping_bag_outlined,
              size: 40,
              color: ShopEasyTheme.goldAccent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some luxury products to fill it up.',
            style: GoogleFonts.poppins(
              color: ShopEasyTheme.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 28),
          TapScaleEffect(
            onTap: () {
              // Direct back to home tab or pop to home
              // By pop, or by triggering Navigator state, here we can just close detailed views if any.
            },
            child: ElevatedButton(
              onPressed: () {
                // If it is inside indexed stack, we can prompt or navigate, let's keep it simple
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text('DISCOVER NOW'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemTile(
      BuildContext context, CartItem item, ShopProvider provider) {
    // Parse color for decoration
    Color itemColorVal = Colors.transparent;
    if (item.selectedColor != null) {
      try {
        if (item.selectedColor!.startsWith('#')) {
          itemColorVal = Color(int.parse(item.selectedColor!.replaceFirst('#', '0xFF')));
        }
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      child: GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(10.0),
        border: Border.all(
          color: ShopEasyTheme.glassBorderWhite,
          width: 0.6,
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                item.product.imageUrls.first,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Variants display
                  if (item.selectedSize != null || item.selectedColor != null)
                    Row(
                      children: [
                        if (item.selectedSize != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Size: ${item.selectedSize}',
                              style: const TextStyle(fontSize: 10, color: ShopEasyTheme.textSecondary),
                            ),
                          ),
                        if (item.selectedSize != null && item.selectedColor != null)
                          const SizedBox(width: 8),
                        if (item.selectedColor != null)
                          Row(
                            children: [
                              const Text('Color: ', style: TextStyle(fontSize: 10, color: ShopEasyTheme.textSecondary)),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: itemColorVal,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    '\$${(item.product.displayPrice * item.quantity).toStringAsFixed(2)}',
                    style: GoogleFonts.montserrat(
                      color: ShopEasyTheme.goldAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Stepper & Delete button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Trash icon
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () {
                    provider.removeFromCart(item.uniqueKey);
                  },
                ),
                // Stepper
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ShopEasyTheme.glassBorderWhite, width: 0.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStepButton(Icons.remove, () {
                        provider.updateCartQuantity(item.uniqueKey, -1);
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildStepButton(Icons.add, () {
                        provider.updateCartQuantity(item.uniqueKey, 1);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 14,
          color: ShopEasyTheme.goldAccent,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isTotal = false, bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.white : ShopEasyTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal
                ? ShopEasyTheme.goldAccent
                : isFree
                    ? Colors.green
                    : Colors.white,
          ),
        ),
      ],
    );
  }
}
