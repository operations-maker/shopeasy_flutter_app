import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/product.dart';
import '../providers/shop_provider.dart';
import '../utils/theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/product_card.dart';
import '../widgets/tap_scale_effect.dart';
import 'checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String heroTag;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.heroTag,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _activeImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    // Default select first size and color if available
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.first;
    }
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final isFav = shopProvider.isWishlisted(widget.product.id);

    // Get related products (same category, excluding this one)
    final relatedProducts = shopProvider.products
        .where((p) => p.category == widget.product.category && p.id != widget.product.id)
        .toList();

    return Scaffold(
      backgroundColor: ShopEasyTheme.background,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery
                Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: double.infinity,
                      child: Hero(
                        tag: widget.heroTag,
                        child: PageView.builder(
                          itemCount: widget.product.imageUrls.length,
                          onPageChanged: (index) {
                            setState(() {
                              _activeImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.network(
                              widget.product.imageUrls[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                    ),
                    // Elegant Gradient Overlay on bottom of image
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ShopEasyTheme.background,
                              ShopEasyTheme.background.withOpacity(0.0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    // Image Dots Indicator
                    if (widget.product.imageUrls.length > 1)
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.product.imageUrls.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _activeImageIndex == index ? 16 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _activeImageIndex == index
                                    ? ShopEasyTheme.goldAccent
                                    : Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Back and Wishlist Header Buttons
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildRoundGlassButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          _buildRoundGlassButton(
                            icon: isFav ? Icons.favorite : Icons.favorite_border_rounded,
                            iconColor: isFav ? Colors.red : ShopEasyTheme.goldAccent,
                            onPressed: () {
                              shopProvider.toggleWishlist(widget.product.id);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFav
                                        ? '${widget.product.name} removed from Wishlist'
                                        : '${widget.product.name} added to Wishlist',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  backgroundColor: ShopEasyTheme.goldAccent,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Details Body
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Text(
                        widget.product.category.toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: ShopEasyTheme.goldAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Title
                      Text(
                        widget.product.name,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 22,
                            ),
                      ),
                      const SizedBox(height: 10),
                      // Ratings & Reviews
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: widget.product.rating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: ShopEasyTheme.goldAccent,
                            ),
                            itemCount: 5,
                            itemSize: 18.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.product.rating} (${widget.product.reviewCount} Reviews)',
                            style: GoogleFonts.poppins(
                              color: ShopEasyTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Price Block
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$${widget.product.displayPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.montserrat(
                              color: ShopEasyTheme.goldAccent,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.product.hasDiscount) ...[
                            const SizedBox(width: 10),
                            Text(
                              '\$${widget.product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: ShopEasyTheme.textMuted,
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.withOpacity(0.4), width: 0.5),
                              ),
                              child: Text(
                                '${widget.product.discountPercentage}% OFF',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Variant: Colors
                      if (widget.product.colors.isNotEmpty) ...[
                        Text(
                          'Colors',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.product.colors.length,
                            itemBuilder: (context, index) {
                              final colorHex = widget.product.colors[index];
                              final isSelected = _selectedColor == colorHex;

                              // Parse hex color string safely
                              Color colorVal = Colors.transparent;
                              try {
                                if (colorHex.startsWith('#')) {
                                  colorVal = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
                                } else {
                                  colorVal = Colors.grey;
                                }
                              } catch (e) {
                                colorVal = Colors.grey;
                              }

                              return GestureDetector(
                                onTap: () => setState(() => _selectedColor = colorHex),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: colorVal,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? ShopEasyTheme.goldAccent
                                          : Colors.white.withOpacity(0.2),
                                      width: isSelected ? 2.5 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: ShopEasyTheme.goldAccent.withOpacity(0.4),
                                              blurRadius: 8,
                                              spreadRadius: 1,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check,
                                          size: 16,
                                          color: colorVal == Colors.white ? Colors.black : Colors.white,
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Variant: Sizes
                      if (widget.product.sizes.isNotEmpty) ...[
                        Text(
                          'Select Size / Option',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          children: widget.product.sizes.map((size) {
                            final isSelected = _selectedSize == size;
                            return TapScaleEffect(
                              onTap: () => setState(() => _selectedSize = size),
                              child: GlassContainer(
                                borderRadius: 12,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                color: isSelected
                                    ? ShopEasyTheme.goldAccent.withOpacity(0.15)
                                    : ShopEasyTheme.glassBg,
                                border: Border.all(
                                  color: isSelected ? ShopEasyTheme.goldAccent : ShopEasyTheme.glassBorderWhite,
                                  width: 1.0,
                                ),
                                child: Text(
                                  size,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? ShopEasyTheme.goldAccent : ShopEasyTheme.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Expandable Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        alignment: Alignment.topCenter,
                        curve: Curves.easeInOut,
                        child: Text(
                          widget.product.description,
                          maxLines: _isDescriptionExpanded ? null : 3,
                          overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: ShopEasyTheme.textSecondary,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isDescriptionExpanded = !_isDescriptionExpanded;
                          });
                        },
                        child: Text(
                          _isDescriptionExpanded ? 'Read Less' : 'Read More',
                          style: const TextStyle(color: ShopEasyTheme.goldAccent),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Related Products Scroll
                      if (relatedProducts.isNotEmpty) ...[
                        Text(
                          'You May Also Like',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 210,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: relatedProducts.length,
                            itemBuilder: (context, index) {
                              final relProduct = relatedProducts[index];
                              return Container(
                                width: 145,
                                margin: const EdgeInsets.only(right: 12),
                                child: ProductCard(
                                  product: relProduct,
                                  isCompact: true,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 100), // padding bottom for buttons
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Glass Bottom Action Buttons
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: GlassContainer(
              height: 70,
              borderRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              border: Border.all(color: ShopEasyTheme.glassBorder, width: 0.8),
              child: Row(
                children: [
                  // Add To Cart Button (Glassy Dark Outline)
                  Expanded(
                    child: TapScaleEffect(
                      onTap: () {
                        shopProvider.addToCart(
                          widget.product,
                          size: _selectedSize,
                          color: _selectedColor,
                        );
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.product.name} added to Cart!',
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: ShopEasyTheme.goldAccent,
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'VIEW CART',
                              textColor: Colors.black,
                              onPressed: () {
                                // Close details page
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: ShopEasyTheme.goldAccent.withOpacity(0.6), width: 1),
                        ),
                        child: Center(
                          child: Text(
                            'ADD TO CART',
                            style: GoogleFonts.poppins(
                              color: ShopEasyTheme.goldAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Buy Now Button (Gold Gradient)
                  Expanded(
                    child: TapScaleEffect(
                      onTap: () {
                        // Quick checkout flow: Add to cart, and navigate to checkout screen
                        shopProvider.addToCart(
                          widget.product,
                          size: _selectedSize,
                          color: _selectedColor,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CheckoutScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: ShopEasyTheme.goldGradient,
                          borderRadius: BorderRadius.circular(14),
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
                            'BUY NOW',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundGlassButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = ShopEasyTheme.goldAccent,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
          border: Border.all(
            color: ShopEasyTheme.glassBorderWhite,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}
