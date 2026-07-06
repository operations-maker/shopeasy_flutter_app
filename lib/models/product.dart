class Product {
  final String id;
  final String name;
  final double price;
  final double? discountPrice;
  final List<String> imageUrls;
  final String category;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> sizes;
  final List<String> colors; // Hex values or names

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.discountPrice,
    required this.imageUrls,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.description,
    this.sizes = const [],
    this.colors = const [],
  });

  // Calculate discount percentage if discountPrice is available
  int get discountPercentage {
    if (discountPrice == null || price <= 0) return 0;
    final discount = price - discountPrice!;
    return ((discount / price) * 100).round();
  }

  // Helper check if discounted
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  // Display price
  double get displayPrice => hasDiscount ? discountPrice! : price;
}

// Realistic list of 25 e-commerce products
final List<Product> mockProducts = [
  // --- ELECTRONICS ---
  Product(
    id: 'elec_1',
    name: 'AeroSound Pro Max ANC Headphones',
    price: 349.99,
    discountPrice: 299.99,
    category: 'Electronics',
    rating: 4.8,
    reviewCount: 1240,
    description: 'Immerse yourself in pure audio bliss with AeroSound Pro Max. Featuring industry-leading Active Noise Cancellation (ANC), 45-hour battery life, and ultra-comfortable memory foam earcups finished in premium matte gold accents. Supports high-res wireless audio and smart assistant integration.',
    imageUrls: [
      'https://picsum.photos/id/1/600/600',
      'https://picsum.photos/id/2/600/600',
      'https://picsum.photos/id/3/600/600',
    ],
    sizes: ['Standard'],
    colors: ['#0D0D0D', '#D4AF37', '#E5E5E5'],
  ),
  Product(
    id: 'elec_2',
    name: 'ChronoShield Luxury Smartwatch v4',
    price: 249.99,
    discountPrice: 199.99,
    category: 'Electronics',
    rating: 4.6,
    reviewCount: 840,
    description: 'Crafted with a stainless steel gold-plated bezel and a vivid AMOLED always-on display, the ChronoShield Smartwatch blends style and wellness. Track sleep quality, blood oxygen levels, heart rate, and over 100 workouts. Water-resistant up to 50 meters.',
    imageUrls: [
      'https://picsum.photos/id/6/600/600',
      'https://picsum.photos/id/7/600/600',
    ],
    sizes: ['40mm', '44mm'],
    colors: ['#D4AF37', '#0D0D0D'],
  ),
  Product(
    id: 'elec_3',
    name: 'VoltStream 100W GaN Charging Hub',
    price: 59.99,
    category: 'Electronics',
    rating: 4.7,
    reviewCount: 310,
    description: 'Compact yet powerful, this GaN fast charger features three USB-C ports and one USB-A port to charge your laptop, smartphone, and tablet simultaneously. Packed with advanced temperature monitoring and power allocation tech.',
    imageUrls: [
      'https://picsum.photos/id/9/600/600',
    ],
    sizes: ['US Plug', 'EU Plug', 'UK Plug'],
    colors: ['#0D0D0D', '#FFFFFF'],
  ),
  Product(
    id: 'elec_4',
    name: 'AuraLens Streamer Webcam 4K',
    price: 189.99,
    discountPrice: 159.99,
    category: 'Electronics',
    rating: 4.5,
    reviewCount: 420,
    description: 'Upgrade your video calls and streams with pristine 4K resolution at 30fps. AuraLens features AI autofocus, low-light correction, and a built-in ring light with customizable warmth settings.',
    imageUrls: [
      'https://picsum.photos/id/10/600/600',
    ],
    sizes: ['Standard'],
    colors: ['#0D0D0D'],
  ),
  Product(
    id: 'elec_5',
    name: 'SoundCube Portable Wireless Speaker',
    price: 79.99,
    category: 'Electronics',
    rating: 4.4,
    reviewCount: 560,
    description: 'Boasting dual acoustic drivers and dual passive radiators, SoundCube delivers deep bass and crystal-clear vocals. Features IPX7 waterproofing, Bluetooth 5.2, and up to 24 hours of non-stop playtime.',
    imageUrls: [
      'https://picsum.photos/id/12/600/600',
    ],
    sizes: ['Standard'],
    colors: ['#0D0D0D', '#D4AF37', '#C0C0C0'],
  ),

  // --- FASHION ---
  Product(
    id: 'fash_1',
    name: 'Classic Gold Accent Cashmere Hoodie',
    price: 149.99,
    discountPrice: 119.99,
    category: 'Fashion',
    rating: 4.9,
    reviewCount: 180,
    description: 'Indulge in absolute comfort with our premium cashmere hoodie. Designed with custom gold-plated zipper details and aglets. Perfectly soft, breathable, and styled for a sleek urban look.',
    imageUrls: [
      'https://picsum.photos/id/14/600/600',
      'https://picsum.photos/id/15/600/600',
    ],
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['#0D0D0D', '#1A1A1A', '#333333'],
  ),
  Product(
    id: 'fash_2',
    name: 'Monarch Gold Thread Leather Jacket',
    price: 299.99,
    category: 'Fashion',
    rating: 4.7,
    reviewCount: 95,
    description: 'Tailored from fine sheepskin leather, this premium biker jacket features hand-stitched gold metallic thread details along the lapels and zippers. Satin lining for a premium slip-on feel.',
    imageUrls: [
      'https://picsum.photos/id/16/600/600',
    ],
    sizes: ['M', 'L', 'XL'],
    colors: ['#0D0D0D'],
  ),
  Product(
    id: 'fash_3',
    name: 'Gilded Frame Classic Aviator Sunglasses',
    price: 120.00,
    discountPrice: 89.99,
    category: 'Fashion',
    rating: 4.6,
    reviewCount: 340,
    description: 'Timeless aviator sunglasses featuring lightweight 18K gold-plated titanium frames and polarized UV400 lenses. Designed to look stunning while offering maximum sun protection.',
    imageUrls: [
      'https://picsum.photos/id/18/600/600',
    ],
    sizes: ['Standard'],
    colors: ['#D4AF37', '#000000'],
  ),
  Product(
    id: 'fash_4',
    name: 'Urban Gold Mesh Running Sneakers',
    price: 110.00,
    category: 'Fashion',
    rating: 4.5,
    reviewCount: 290,
    description: 'Ultra-lightweight mesh knit shoes with flexible responsive cushioning. Finished with dynamic gold stripes and heel clips for a sporty yet luxury vibe.',
    imageUrls: [
      'https://picsum.photos/id/20/600/600',
      'https://picsum.photos/id/21/600/600',
    ],
    sizes: ['US 8', 'US 9', 'US 10', 'US 11'],
    colors: ['#000000', '#FFFFFF', '#D4AF37'],
  ),
  Product(
    id: 'fash_5',
    name: 'Golden Crest Woolen Overcoat',
    price: 249.99,
    discountPrice: 199.99,
    category: 'Fashion',
    rating: 4.8,
    reviewCount: 110,
    description: 'A structured, double-breasted overcoat tailored in rich virgin wool. Features embossed gold buttons inspired by historical crests. An elegant outer layer for cold climates.',
    imageUrls: [
      'https://picsum.photos/id/22/600/600',
    ],
    sizes: ['S', 'M', 'L'],
    colors: ['#0D0D0D', '#2B1A0A'],
  ),

  // --- HOME & LIVING ---
  Product(
    id: 'home_1',
    name: 'Luna Glassmorphism LED Desk Lamp',
    price: 89.99,
    discountPrice: 69.99,
    category: 'Home',
    rating: 4.7,
    reviewCount: 450,
    description: 'Add a contemporary touch to your workspace. Featuring a curved frosted glass panels diffuser and a brushed brass/gold base. Stepless touch dimming and three color temperatures.',
    imageUrls: [
      'https://picsum.photos/id/24/600/600',
      'https://picsum.photos/id/25/600/600',
    ],
    sizes: ['Standard'],
    colors: ['#D4AF37', '#C0C0C0'],
  ),
  Product(
    id: 'home_2',
    name: 'Royal Velvet Cushion & Throw Set',
    price: 45.00,
    category: 'Home',
    rating: 4.5,
    reviewCount: 210,
    description: 'An elegant addition to any sofa or bed. Set includes two premium plush velvet cushion covers and a matching soft knit throw, featuring subtle gold-toned jacquard patterns.',
    imageUrls: [
      'https://picsum.photos/id/28/600/600',
    ],
    sizes: ['18x18 inch'],
    colors: ['#1C2A3A', '#2E1A47', '#0F2618'],
  ),
  Product(
    id: 'home_3',
    name: 'Minimalist Gold Rim Ceramic Dinner Set',
    price: 159.99,
    discountPrice: 129.99,
    category: 'Home',
    rating: 4.8,
    reviewCount: 180,
    description: 'Exquisite 16-piece ceramic dinnerware set serving four. Each piece features a organic shape and is hand-painted with a real 24K gold rim. Microwave and dishwasher safe.',
    imageUrls: [
      'https://picsum.photos/id/30/600/600',
      'https://picsum.photos/id/31/600/600',
    ],
    sizes: ['16-Piece Set'],
    colors: ['#FFFFFF', '#0D0D0D'],
  ),
  Product(
    id: 'home_4',
    name: 'AromaTherapy Ultrasonic Gold Diffuser',
    price: 65.00,
    category: 'Home',
    rating: 4.6,
    reviewCount: 390,
    description: 'Relax and unwind with this ultrasonic essential oil diffuser. Crafted with an elegant ceramic shell with a gold-tone lattice cutout that glows beautifully under the warm LED light.',
    imageUrls: [
      'https://picsum.photos/id/36/600/600',
    ],
    sizes: ['150ml', '300ml'],
    colors: ['#D4AF37', '#FFFFFF'],
  ),
  Product(
    id: 'home_5',
    name: 'Gilded Frame Mirror & Wall Art Trio',
    price: 199.99,
    discountPrice: 179.99,
    category: 'Home',
    rating: 4.3,
    reviewCount: 95,
    description: 'Brighten up your hallway or living room with this elegant trio of three gold-finished floating frames, featuring a central HD mirror and two matching abstract prints.',
    imageUrls: [
      'https://picsum.photos/id/42/600/600',
    ],
    sizes: ['Set of 3'],
    colors: ['#D4AF37'],
  ),

  // --- BEAUTY & PERSONAL CARE ---
  Product(
    id: 'beau_1',
    name: 'Aurum Elixir 24K Gold Face Serum',
    price: 75.00,
    discountPrice: 59.99,
    category: 'Beauty',
    rating: 4.9,
    reviewCount: 680,
    description: 'Infused with real 24K gold flakes, rosehip oil, and hyaluronic acid, this luxury serum deeply hydrates, reduces fine lines, and leaves a gorgeous, radiant champagne glow.',
    imageUrls: [
      'https://picsum.photos/id/48/600/600',
      'https://picsum.photos/id/49/600/600',
    ],
    sizes: ['30ml', '50ml'],
    colors: ['#D4AF37'],
  ),
  Product(
    id: 'beau_2',
    name: 'Monarch Gold Beard Grooming Kit',
    price: 49.99,
    category: 'Beauty',
    rating: 4.7,
    reviewCount: 230,
    description: 'Everything a modern gentleman needs. Includes premium sandalwood beard oil, organic wax, a gold-plated comb, dual-sided boar bristle brush, and stainless steel trimming scissors.',
    imageUrls: [
      'https://picsum.photos/id/50/600/600',
    ],
    sizes: ['Full Kit'],
    colors: ['#D4AF37', '#0D0D0D'],
  ),
  Product(
    id: 'beau_3',
    name: 'Nectar Noir Premium Oud Perfume',
    price: 125.00,
    discountPrice: 99.99,
    category: 'Beauty',
    rating: 4.8,
    reviewCount: 410,
    description: 'An intoxicating, long-lasting unisex scent combining rich Cambodian Oud, smoky amber, sweet vanilla, and gold-leaf saffron notes. Encased in a beautiful heavy glass bottle.',
    imageUrls: [
      'https://picsum.photos/id/53/600/600',
    ],
    sizes: ['50ml', '100ml'],
    colors: ['#0D0D0D'],
  ),
  Product(
    id: 'beau_4',
    name: 'Gilded Radiance Ionic Hair Dryer',
    price: 139.99,
    category: 'Beauty',
    rating: 4.6,
    reviewCount: 280,
    description: 'Dry your hair in half the time without heat damage. Uses advanced negative ion technology to eliminate frizz, featuring a sleek champagne gold chassis and multiple magnetic attachments.',
    imageUrls: [
      'https://picsum.photos/id/54/600/600',
    ],
    sizes: ['Standard'],
    colors: ['#D4AF37', '#0D0D0D'],
  ),
  Product(
    id: 'beau_5',
    name: 'Velvet Matte Lipstick Set - Gold Edition',
    price: 38.00,
    discountPrice: 29.99,
    category: 'Beauty',
    rating: 4.5,
    reviewCount: 150,
    description: 'Four highly pigmented, long-wear matte lipsticks ranging from classic red to nude pink. Presented in a premium gold-plated custom box with internal mirrors.',
    imageUrls: [
      'https://picsum.photos/id/59/600/600',
    ],
    sizes: ['4-Pack'],
    colors: ['#D4AF37'],
  ),

  // --- FITNESS & SPORT ---
  Product(
    id: 'fit_1',
    name: 'Apex Gold Smart Kettlebell 12-24kg',
    price: 179.99,
    discountPrice: 149.99,
    category: 'Fitness',
    rating: 4.7,
    reviewCount: 120,
    description: 'Replace an entire stack of weights. The Apex adjustable kettlebell features a quick-select dial mechanism with weights ranging from 12kg to 24kg, accented in a striking gold powder coat.',
    imageUrls: [
      'https://picsum.photos/id/60/600/600',
      'https://picsum.photos/id/61/600/600',
    ],
    sizes: ['Adjustable'],
    colors: ['#0D0D0D', '#D4AF37'],
  ),
  Product(
    id: 'fit_2',
    name: 'UltraGrip Eco-Friendly Gold Yoga Mat',
    price: 55.00,
    category: 'Fitness',
    rating: 4.6,
    reviewCount: 310,
    description: 'Engineered from biodegradable tree rubber with a moisture-wicking cork top layer. Embellished with beautiful gold alignment lines printed with non-toxic water-based inks.',
    imageUrls: [
      'https://picsum.photos/id/64/600/600',
    ],
    sizes: ['6mm Thickness'],
    colors: ['#C8B195'],
  ),
  Product(
    id: 'fit_3',
    name: 'HydraGold Double-Walled Water Bottle',
    price: 32.00,
    category: 'Fitness',
    rating: 4.8,
    reviewCount: 540,
    description: 'Keep your drinks ice-cold for 24 hours or piping hot for 12. Crafted with culinary-grade stainless steel with a sleek gold metallic powder coat and a leakproof leak ring.',
    imageUrls: [
      'https://picsum.photos/id/72/600/600',
    ],
    sizes: ['500ml', '750ml'],
    colors: ['#D4AF37', '#000000'],
  ),
  Product(
    id: 'fit_4',
    name: 'Titanium Speed Rope with Gold Handles',
    price: 24.99,
    discountPrice: 19.99,
    category: 'Fitness',
    rating: 4.5,
    reviewCount: 180,
    description: 'Engineered for double-unders and cardio speed work. Features precision ball bearings and knurled gold aluminum handles for a secure grip during sweaty workouts.',
    imageUrls: [
      'https://picsum.photos/id/74/600/600',
    ],
    sizes: ['10ft Adjustable'],
    colors: ['#D4AF37', '#0D0D0D'],
  ),
  Product(
    id: 'fit_5',
    name: 'PulseForce Luxury Percussion Massager',
    price: 199.99,
    discountPrice: 159.99,
    category: 'Fitness',
    rating: 4.7,
    reviewCount: 220,
    description: 'Relieve muscle soreness and stiffness. PulseForce features a powerful brushless motor, 6 speeds, 5 attachment heads, and is styled with a gorgeous carbon fiber shell and gold trim.',
    imageUrls: [
      'https://picsum.photos/id/76/600/600',
    ],
    sizes: ['Standard'],
    colors: ['#0D0D0D', '#D4AF37'],
  ),
];
