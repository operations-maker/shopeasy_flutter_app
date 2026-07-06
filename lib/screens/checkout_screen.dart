import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/shop_provider.dart';
import '../utils/theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/tap_scale_effect.dart';
import 'confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late TextEditingController _addressController;
  bool _isEditingAddress = false;

  @override
  void initState() {
    super.initState();
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    _addressController = TextEditingController(text: shopProvider.shippingAddress);
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final cartItems = shopProvider.cartItems;

    return Scaffold(
      backgroundColor: ShopEasyTheme.background,
      appBar: AppBar(
        title: const Text('CHECKOUT'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ShopEasyTheme.goldAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address Header & Section
              _buildSectionHeader('DELIVERY ADDRESS'),
              const SizedBox(height: 10),
              GlassContainer(
                borderRadius: 18,
                padding: const EdgeInsets.all(16.0),
                border: Border.all(color: ShopEasyTheme.glassBorder, width: 0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.location_on_outlined, color: ShopEasyTheme.goldAccent, size: 20),
                            SizedBox(width: 6),
                            Text(
                              'Shipping Location',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isEditingAddress = !_isEditingAddress;
                              if (!_isEditingAddress) {
                                shopProvider.setShippingAddress(_addressController.text);
                              }
                            });
                          },
                          child: Text(
                            _isEditingAddress ? 'SAVE' : 'EDIT',
                            style: const TextStyle(color: ShopEasyTheme.goldAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _isEditingAddress
                        ? TextField(
                            controller: _addressController,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            maxLines: 2,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              fillColor: Colors.white.withOpacity(0.04),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: ShopEasyTheme.glassBorderWhite),
                              ),
                            ),
                          )
                        : Text(
                            shopProvider.shippingAddress,
                            style: GoogleFonts.poppins(
                              color: ShopEasyTheme.textSecondary,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Payment Methods
              _buildSectionHeader('PAYMENT METHOD'),
              const SizedBox(height: 10),
              _buildPaymentMethodTile(
                context: context,
                method: 'UPI',
                title: 'UPI (GPay / PhonePe / Paytm)',
                icon: Icons.qr_code_rounded,
                shopProvider: shopProvider,
              ),
              const SizedBox(height: 10),
              _buildPaymentMethodTile(
                context: context,
                method: 'CARD',
                title: 'Credit / Debit Card',
                icon: Icons.credit_card_rounded,
                shopProvider: shopProvider,
              ),
              const SizedBox(height: 10),
              _buildPaymentMethodTile(
                context: context,
                method: 'COD',
                title: 'Cash on Delivery (COD)',
                icon: Icons.payments_outlined,
                shopProvider: shopProvider,
              ),
              const SizedBox(height: 24),

              // Order Summary
              _buildSectionHeader('ORDER SUMMARY'),
              const SizedBox(height: 10),
              GlassContainer(
                borderRadius: 18,
                padding: const EdgeInsets.all(16.0),
                border: Border.all(color: ShopEasyTheme.glassBorderWhite, width: 0.6),
                child: Column(
                  children: [
                    // Items List view
                    ...cartItems.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.quantity}x  ${item.product.name}',
                                  style: GoogleFonts.poppins(color: ShopEasyTheme.textSecondary, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '\$${(item.product.displayPrice * item.quantity).toStringAsFixed(2)}',
                                style: GoogleFonts.montserrat(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )),
                    const Divider(height: 20),
                    // Totals
                    _buildPricingRow('Subtotal', '\$${shopProvider.cartSubtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _buildPricingRow(
                      'Delivery Fee',
                      shopProvider.deliveryFee == 0.0
                          ? 'FREE'
                          : '\$${shopProvider.deliveryFee.toStringAsFixed(2)}',
                    ),
                    const Divider(height: 24, thickness: 1),
                    _buildPricingRow('Grand Total', '\$${shopProvider.cartTotal.toStringAsFixed(2)}', isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Place Order Button
              TapScaleEffect(
                onTap: () {
                  // Ensure current address changes are saved
                  if (_isEditingAddress) {
                    shopProvider.setShippingAddress(_addressController.text);
                  }

                  // Place order and navigate to confirmation screen
                  final placedOrder = shopProvider.placeOrder();
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ConfirmationScreen(order: placedOrder),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
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
                  child: Center(
                    child: Text(
                      'PLACE ORDER',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        color: ShopEasyTheme.goldAccent,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required BuildContext context,
    required String method,
    required String title,
    required IconData icon,
    required ShopProvider shopProvider,
  }) {
    final isSelected = shopProvider.selectedPaymentMethod == method;
    return TapScaleEffect(
      onTap: () => shopProvider.setPaymentMethod(method),
      child: GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: isSelected ? ShopEasyTheme.goldAccent.withOpacity(0.12) : ShopEasyTheme.glassBg,
        border: Border.all(
          color: isSelected ? ShopEasyTheme.goldAccent : ShopEasyTheme.glassBorderWhite,
          width: isSelected ? 1.5 : 0.8,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? ShopEasyTheme.goldAccent : ShopEasyTheme.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : ShopEasyTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ShopEasyTheme.goldAccent : ShopEasyTheme.textMuted,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: ShopEasyTheme.goldAccent,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 15 : 12,
            color: isTotal ? Colors.white : ShopEasyTheme.textSecondary,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: isTotal ? 16 : 13,
            color: isTotal ? ShopEasyTheme.goldAccent : Colors.white,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
