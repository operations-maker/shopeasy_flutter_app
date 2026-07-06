import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';
import '../models/product.dart';
import '../providers/shop_provider.dart';
import '../utils/theme.dart';
import '../screens/product_detail_screen.dart';
import 'glass_container.dart';
import 'tap_scale_effect.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isCompact;

  const ProductCard({
    super.key,
    required this.product,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final isFav = shopProvider.isWishlisted(product.id);

    final heroTag = 'product_image_${product.id}_${isCompact ? "compact" : "grid"}';

    return TapScaleEffect(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (context, animation, secondaryAnimation) =>
                ProductDetailScreen(product: product, heroTag: heroTag),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: GlassContainer(
        borderRadius: 16.0,
        padding: const EdgeInsets.all(8.0),
        border: Border.all(
          color: ShopEasyTheme.glassBorder,
          width: 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Hero(
                        tag: heroTag,
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrls.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[900]!,
                            highlightColor: Colors.grey[800]!,
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error_outline,
                            color: ShopEasyTheme.goldAccent,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Discount Badge
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ShopEasyTheme.goldAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${product.discountPercentage}% OFF',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Wishlist Button
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : ShopEasyTheme.textSecondary,
                        size: 20,
                      ),
                      onPressed: () {
                        shopProvider.toggleWishlist(product.id);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFav
                                  ? '${product.name} removed from Wishlist'
                                  : '${product.name} added to Wishlist',
                              style: const TextStyle(color: Colors.black),
                            ),
                            backgroundColor: ShopEasyTheme.goldAccent,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Title & Info
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: isCompact ? 12 : 14,
                    color: ShopEasyTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: 2),
            // Rating
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              children: [
                RatingBarIndicator(
                  rating: product.rating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: ShopEasyTheme.goldAccent,
                  ),
                  itemCount: 5,
                  itemSize: 12.0,
                  direction: Axis.horizontal,
                ),
                Text(
                  '(${product.reviewCount})',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 9,
                        color: ShopEasyTheme.textMuted,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Prices
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              children: [
                Text(
                  '\$${product.displayPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: isCompact ? 12 : 14,
                        color: ShopEasyTheme.goldAccent,
                      ),
                ),
                if (product.hasDiscount)
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: isCompact ? 9 : 11,
                      color: ShopEasyTheme.textMuted,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
