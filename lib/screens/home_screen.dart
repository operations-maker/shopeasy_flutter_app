import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/shop_provider.dart';
import '../utils/theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/product_card.dart';
import '../widgets/tap_scale_effect.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _promoBanners = [
    {
      'title': 'GILDED LUXURY WEEK',
      'subtitle': 'Up to 40% Off Premium Brands',
      'tag': 'EXTENDED',
      'image': 'https://picsum.photos/id/102/800/400',
    },
    {
      'title': 'AUDIO REVOLUTION',
      'subtitle': 'Experience AeroSound Pro Max',
      'tag': 'NEW',
      'image': 'https://picsum.photos/id/2/800/400',
    },
    {
      'title': 'ESSENTIAL OILS & GLOW',
      'subtitle': 'Flat 20% Off Aurum Face Serums',
      'tag': 'HOT',
      'image': 'https://picsum.photos/id/48/800/400',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.all_inclusive_rounded},
    {'name': 'Electronics', 'icon': Icons.phone_iphone_rounded},
    {'name': 'Fashion', 'icon': Icons.checkroom_rounded},
    {'name': 'Home', 'icon': Icons.chair_rounded},
    {'name': 'Beauty', 'icon': Icons.face_retouching_natural_rounded},
    {'name': 'Fitness', 'icon': Icons.fitness_center_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    // Filter deals (discounted products)
    final deals = shopProvider.products.where((p) => p.hasDiscount).toList();

    // Filter recommended products based on query and active category chip
    final recommended = shopProvider.products.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: ShopEasyTheme.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Premium Header with Brand Logo, Search Bar, and Profile
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    // Brand Logo
                    ShaderMask(
                      shaderCallback: ShopEasyTheme.goldGradient.createShader,
                      child: Text(
                        'SE',
                        style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Search Field
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: GlassContainer(
                          borderRadius: 16,
                          blur: 8.0,
                          border: Border.all(
                            color: ShopEasyTheme.glassBorder,
                            width: 0.6,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_rounded,
                                color: ShopEasyTheme.goldAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  onChanged: (val) {
                                    setState(() {
                                      _searchQuery = val;
                                    });
                                  },
                                  style: GoogleFonts.poppins(
                                    color: ShopEasyTheme.textPrimary,
                                    fontSize: 13,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search electronics, fashion...',
                                    hintStyle: GoogleFonts.poppins(
                                      color: ShopEasyTheme.textMuted,
                                      fontSize: 13,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              if (_searchQuery.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close_rounded,
                                    color: ShopEasyTheme.textSecondary,
                                    size: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Profile Avatar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: ShopEasyTheme.goldAccent,
                      child: CircleAvatar(
                        radius: 19,
                        backgroundImage: CachedNetworkImageProvider(
                          shopProvider.userAvatar,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Promotional Carousel Slider
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 165.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.88,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                  items: _promoBanners.map((banner) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                // Background Banner Image
                                Positioned.fill(
                                  child: CachedNetworkImage(
                                    imageUrl: banner['image'],
                                    fit: BoxFit.cover,
                                    errorWidget: (c, u, e) => Container(
                                      color: ShopEasyTheme.surface,
                                    ),
                                  ),
                                ),
                                // Gradient Overlay for text contrast
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.85),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                    ),
                                  ),
                                ),
                                // Promotional Text
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ShopEasyTheme.goldAccent,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          banner['tag'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        banner['title'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        banner['subtitle'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: ShopEasyTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            // Horizontal Categories list
            SliverToBoxAdapter(
              child: Container(
                height: 48,
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat['name'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: TapScaleEffect(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat['name'];
                          });
                        },
                        child: GlassContainer(
                          borderRadius: 14,
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          color: isSelected
                              ? ShopEasyTheme.goldAccent.withOpacity(0.15)
                              : ShopEasyTheme.glassBg,
                          border: Border.all(
                            color: isSelected
                                ? ShopEasyTheme.goldAccent
                                : ShopEasyTheme.glassBorderWhite,
                            width: 0.8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                cat['icon'],
                                color: isSelected
                                    ? ShopEasyTheme.goldAccent
                                    : ShopEasyTheme.textSecondary,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                cat['name'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected
                                      ? ShopEasyTheme.goldAccent
                                      : ShopEasyTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Deals of the Day Header
            if (deals.isNotEmpty && _selectedCategory == 'All' && _searchQuery.isEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Deals of the Day',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              letterSpacing: 0.5,
                            ),
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.timer_outlined,
                            color: ShopEasyTheme.goldAccent,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Ends in 04h : 23m',
                            style: TextStyle(
                              color: ShopEasyTheme.goldAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Deals horizontal scroll list
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: deals.length,
                    itemBuilder: (context, index) {
                      final product = deals[index];
                      return Container(
                        width: 155,
                        margin: const EdgeInsets.only(right: 14.0),
                        child: ProductCard(product: product, isCompact: true),
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],

            // Recommended for You Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  _searchQuery.isNotEmpty
                      ? 'Search Results (${recommended.length})'
                      : _selectedCategory == 'All'
                          ? 'Recommended for You'
                          : '$_selectedCategory Collections',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),

            // Recommended Products 2-Column Grid
            if (recommended.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48.0),
                  child: Center(
                    child: Text(
                      'No products found matching your filter.',
                      style: TextStyle(color: ShopEasyTheme.textSecondary),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 100.0),
                // Extra bottom padding for floating navigation bar
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ProductCard(product: recommended[index]);
                    },
                    childCount: recommended.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
