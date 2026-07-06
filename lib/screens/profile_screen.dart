import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/shop_provider.dart';
import '../utils/theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/tap_scale_effect.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      backgroundColor: ShopEasyTheme.background,
      appBar: AppBar(
        title: const Text('MY PROFILE'),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // padding for floating bottom nav
          child: Column(
            children: [
              // Profile Header Info Card
              _buildProfileCard(context, shopProvider),
              const SizedBox(height: 24),

              // Menu Options Group
              _buildMenuSection(context, shopProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, ShopProvider provider) {
    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(20.0),
      border: Border.all(color: ShopEasyTheme.glassBorder, width: 0.8),
      child: Row(
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: ShopEasyTheme.goldGradient,
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(provider.userAvatar),
            ),
          ),
          const SizedBox(width: 20),

          // Name / Email Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.userName,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.userEmail,
                  style: GoogleFonts.poppins(
                    color: ShopEasyTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                // Edit details button
                TapScaleEffect(
                  onTap: () => _showEditProfileDialog(context, provider),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ShopEasyTheme.goldAccent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ShopEasyTheme.goldAccent.withOpacity(0.4), width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.edit_outlined, color: ShopEasyTheme.goldAccent, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'EDIT PROFILE',
                          style: TextStyle(
                            color: ShopEasyTheme.goldAccent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }

  Widget _buildMenuSection(BuildContext context, ShopProvider provider) {
    return Column(
      children: [
        _buildGlassMenuTile(
          icon: Icons.local_mall_outlined,
          title: 'My Orders',
          subtitle: '${provider.orders.length} orders placed',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OrdersHistoryScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildGlassMenuTile(
          icon: Icons.location_on_outlined,
          title: 'Addresses',
          subtitle: 'Manage your shipping locations',
          onTap: () => _showInfoSnackBar(context, 'Shipping locations editing is integrated in Checkout screen!'),
        ),
        const SizedBox(height: 12),
        _buildGlassMenuTile(
          icon: Icons.payment_outlined,
          title: 'Payment Methods',
          subtitle: 'Default: ${provider.selectedPaymentMethod}',
          onTap: () => _showInfoSnackBar(context, 'UPI/Card configs are selected during Checkout!'),
        ),
        const SizedBox(height: 12),
        _buildGlassMenuTile(
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'App themes, notifications, preferences',
          onTap: () => _showInfoSnackBar(context, 'Settings are pre-configured to Gold Glassmorphism Dark Theme.'),
        ),
        const SizedBox(height: 12),
        _buildGlassMenuTile(
          icon: Icons.help_outline_rounded,
          title: 'Help & Support',
          subtitle: 'FAQ, live chat assistance',
          onTap: () => _showInfoSnackBar(context, 'Support team is available at support@shopeasy.com'),
        ),
        const SizedBox(height: 12),
        _buildGlassMenuTile(
          icon: Icons.logout_rounded,
          title: 'Logout',
          subtitle: 'Sign out of your account',
          iconColor: Colors.redAccent,
          onTap: () => _showInfoSnackBar(context, 'You have been logged out (Mock action).'),
        ),
      ],
    );
  }

  Widget _buildGlassMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = ShopEasyTheme.goldAccent,
  }) {
    return TapScaleEffect(
      onTap: onTap,
      child: GlassContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        border: Border.all(color: ShopEasyTheme.glassBorderWhite, width: 0.6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: ShopEasyTheme.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: ShopEasyTheme.textMuted,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: ShopEasyTheme.goldAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, ShopProvider provider) {
    final nameCont = TextEditingController(text: provider.userName);
    final emailCont = TextEditingController(text: provider.userEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ShopEasyTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: ShopEasyTheme.goldAccent, width: 1),
          ),
          title: Text(
            'Edit Profile Info',
            style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCont,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCont,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL', style: TextStyle(color: ShopEasyTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                provider.updateProfile(name: nameCont.text, email: emailCont.text);
                Navigator.of(context).pop();
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }
}

// Order History sub-screen
class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final orders = shopProvider.orders;

    return Scaffold(
      backgroundColor: ShopEasyTheme.background,
      appBar: AppBar(
        title: const Text('ORDER HISTORY'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ShopEasyTheme.goldAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_shipping_outlined, color: ShopEasyTheme.textMuted, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'No orders placed yet',
                      style: GoogleFonts.poppins(color: ShopEasyTheme.textSecondary),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                physics: const BouncingScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: GlassContainer(
                      borderRadius: 20,
                      padding: const EdgeInsets.all(16.0),
                      border: Border.all(color: ShopEasyTheme.glassBorderWhite, width: 0.6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.orderId,
                                style: GoogleFonts.montserrat(
                                  color: ShopEasyTheme.goldAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                                style: const TextStyle(color: ShopEasyTheme.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          // List items in this order
                          ...order.items.map((item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  '${item.quantity}x ${item.product.name}',
                                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Est. Delivery: ${order.estimatedDelivery}',
                                style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '\$${order.totalAmount.toStringAsFixed(2)}',
                                style: GoogleFonts.montserrat(
                                  color: ShopEasyTheme.goldAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
