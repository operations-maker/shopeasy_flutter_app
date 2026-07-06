import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/shop_provider.dart';
import '../utils/theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/tap_scale_effect.dart';
import 'main_navigation.dart';

class ConfirmationScreen extends StatefulWidget {
  final ShopOrder order;

  const ConfirmationScreen({
    super.key,
    required this.order,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShopEasyTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulse Gold Success Icon
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ShopEasyTheme.goldAccent.withOpacity(0.08),
                    border: Border.all(
                      color: ShopEasyTheme.goldAccent.withOpacity(0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ShopEasyTheme.goldAccent.withOpacity(0.12),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: ShopEasyTheme.goldAccent,
                    size: 80,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Title
              Text(
                'ORDER PLACED SUCCESSFULLY!',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Thank you for shopping with ShopEasy. Your order is being processed.',
                style: GoogleFonts.poppins(
                  color: ShopEasyTheme.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              // Order Details Card
              GlassContainer(
                borderRadius: 20,
                padding: const EdgeInsets.all(20.0),
                border: Border.all(color: ShopEasyTheme.glassBorder, width: 0.8),
                child: Column(
                  children: [
                    _buildDetailRow('Order ID', widget.order.orderId),
                    const SizedBox(height: 12),
                    _buildDetailRow('Estimated Delivery', widget.order.estimatedDelivery),
                    const SizedBox(height: 12),
                    _buildDetailRow('Payment Mode', widget.order.paymentMethod == 'COD' ? 'Cash on Delivery' : widget.order.paymentMethod),
                    const Divider(height: 28, thickness: 1),
                    _buildDetailRow(
                      'Total Amount',
                      '\$${widget.order.totalAmount.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Continue Shopping Button
              TapScaleEffect(
                onTap: () {
                  // Pop back to home tab clean state
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainNavigationScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Container(
                  height: 52,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: ShopEasyTheme.goldGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ShopEasyTheme.goldAccent.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'CONTINUE SHOPPING',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isTotal ? Colors.white : ShopEasyTheme.textSecondary,
            fontSize: 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(
            color: isTotal ? ShopEasyTheme.goldAccent : Colors.white,
            fontSize: isTotal ? 16 : 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
