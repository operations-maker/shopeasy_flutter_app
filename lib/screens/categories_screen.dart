import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/shop_provider.dart';
import '../utils/theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/product_card.dart';
import '../widgets/tap_scale_effect.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {
      'name': 'Electronics',
      'icon': Icons.phone_iphone_rounded,
      'image': 'https://picsum.photos/id/1/400/200',
      'description': 'Gadgets, chargers, audio gear',
    },
    {
      'name': 'Fashion',
      'icon': Icons.checkroom_rounded,
      'image': 'https://picsum.photos/id/14/400/200',
      'description': 'Luxury cashmere & leather apparel',
    },
    {
      'name': 'Home',
      'icon': Icons.chair_rounded,
      'image': 'https://picsum.photos/id/24/400/200',
      'description': 'Desk lighting & home decor sets',
    },
    {
      'name': 'Beauty',
      'icon': Icons.face_retouching_natural_rounded,
      'image': 'https://picsum.photos/id/48/400/200',
      'description': 'Serums, perfumes, and care sets',
    },
    {
      'name': 'Fitness',
      'icon': Icons.fitness_center_rounded,
      'image': 'https://picsum.photos/id/60/400/200',
      'description': 'Premium gym gear & kettlebells',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      backgroundColor: ShopEasyTheme.background,
      appBar: AppBar(
        title: const Text('CATEGORIES'),
      ),
      body: SafeArea(
        bottom: false,
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // padding for floating bottom nav
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 16,
            childAspectRatio: 2.1,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final cat = _categories[index];
            final productCount = shopProvider.products
                .where((p) => p.category.toLowerCase() == cat['name'].toString().toLowerCase())
                .length;

            return TapScaleEffect(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategoryProductsScreen(
                      categoryName: cat['name'],
                      categoryIcon: cat['icon'],
                    ),
                  ),
                );
              },
              child: GlassContainer(
                borderRadius: 20,
                padding: EdgeInsets.zero,
                border: Border.all(
                  color: ShopEasyTheme.glassBorder,
                  width: 0.8,
                ),
                child: Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Opacity(
                          opacity: 0.25,
                          child: Image.network(
                            cat['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        cat['icon'],
                                        color: ShopEasyTheme.goldAccent,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        cat['name'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    cat['description'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: ShopEasyTheme.textSecondary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ShopEasyTheme.goldAccent.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: ShopEasyTheme.goldAccent.withOpacity(0.3),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      '$productCount Products',
                                      style: GoogleFonts.poppins(
                                        color: ShopEasyTheme.goldAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: ShopEasyTheme.goldAccent,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
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

// Sub-screen for filtered categories
class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final categoryProducts = shopProvider.products
        .where((p) => p.category.toLowerCase() == categoryName.toLowerCase())
        .toList();

    return Scaffold(
      backgroundColor: ShopEasyTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(categoryIcon, color: ShopEasyTheme.goldAccent, size: 20),
            const SizedBox(width: 8),
            Text(categoryName.toUpperCase()),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ShopEasyTheme.goldAccent),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: categoryProducts.isEmpty
            ? const Center(
                child: Text(
                  'No products found in this category.',
                  style: TextStyle(color: ShopEasyTheme.textSecondary),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                itemCount: categoryProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: categoryProducts[index]);
                },
              ),
      ),
    );
  }
}
