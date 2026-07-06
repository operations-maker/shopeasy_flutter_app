import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? selectedSize;
  final String? selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
  });

  // Unique identifier for items with variations
  String get uniqueKey => '${product.id}_${selectedSize ?? ''}_${selectedColor ?? ''}';
}

class ShopOrder {
  final String orderId;
  final DateTime orderDate;
  final double totalAmount;
  final List<CartItem> items;
  final String shippingAddress;
  final String paymentMethod;
  final String estimatedDelivery;

  ShopOrder({
    required this.orderId,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.estimatedDelivery,
  });
}

class ShopProvider with ChangeNotifier {
  // All products
  final List<Product> _products = List.from(mockProducts);
  List<Product> get products => _products;

  // Wishlist set of product IDs
  final Set<String> _wishlistProductIds = {};
  Set<String> get wishlistProductIds => _wishlistProductIds;

  // Cart: uniqueKey -> CartItem
  final Map<String, CartItem> _cart = {};
  List<CartItem> get cartItems => _cart.values.toList();
  int get cartCount => _cart.values.fold(0, (sum, item) => sum + item.quantity);

  // User details (editable)
  String _userName = 'Alex Mercer';
  String _userEmail = 'alex.mercer@shopeasy.com';
  String _userAvatar = 'https://picsum.photos/id/1025/200/200'; // Cute dog / person
  String _shippingAddress = '742 Evergreen Terrace, Springfield, OR 97477';
  String _selectedPaymentMethod = 'UPI';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userAvatar => _userAvatar;
  String get shippingAddress => _shippingAddress;
  String get selectedPaymentMethod => _selectedPaymentMethod;

  // Order history
  final List<ShopOrder> _orders = [];
  List<ShopOrder> get orders => _orders;
  ShopOrder? _latestOrder;
  ShopOrder? get latestOrder => _latestOrder;

  // Cart calculations
  double get cartSubtotal => _cart.values.fold(
      0.0, (sum, item) => sum + (item.product.displayPrice * item.quantity));
  
  double get deliveryFee => cartSubtotal > 150.0 ? 0.0 : 15.00;
  double get cartTotal => cartSubtotal + deliveryFee;

  // --- WISHLIST LOGIC ---
  bool isWishlisted(String productId) {
    return _wishlistProductIds.contains(productId);
  }

  void toggleWishlist(String productId) {
    if (_wishlistProductIds.contains(productId)) {
      _wishlistProductIds.remove(productId);
    } else {
      _wishlistProductIds.add(productId);
    }
    notifyListeners();
  }

  // --- CART LOGIC ---
  void addToCart(Product product, {String? size, String? color, int quantity = 1}) {
    final tempItem = CartItem(
      product: product,
      selectedSize: size,
      selectedColor: color,
    );
    final key = tempItem.uniqueKey;

    if (_cart.containsKey(key)) {
      _cart[key]!.quantity += quantity;
    } else {
      _cart[key] = CartItem(
        product: product,
        quantity: quantity,
        selectedSize: size,
        selectedColor: color,
      );
    }
    notifyListeners();
  }

  void removeFromCart(String uniqueKey) {
    if (_cart.containsKey(uniqueKey)) {
      _cart.remove(uniqueKey);
      notifyListeners();
    }
  }

  void updateCartQuantity(String uniqueKey, int delta) {
    if (_cart.containsKey(uniqueKey)) {
      final item = _cart[uniqueKey]!;
      final newQuantity = item.quantity + delta;
      if (newQuantity <= 0) {
        _cart.remove(uniqueKey);
      } else {
        item.quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // --- PROFILE & SETTINGS ---
  void updateProfile({required String name, required String email}) {
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }

  void setShippingAddress(String address) {
    _shippingAddress = address;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  // --- CHECKOUT & ORDER PLACE ---
  ShopOrder placeOrder() {
    final random = Random();
    final orderId = 'SE-${100000 + random.nextInt(900000)}';
    
    // Delivery estimated 3-5 days from now
    final deliveryDays = 3 + random.nextInt(3);
    final deliveryDate = DateTime.now().add(Duration(days: deliveryDays));
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final estimatedDeliveryStr = '${deliveryDate.day} ${months[deliveryDate.month - 1]}, ${deliveryDate.year}';

    final order = ShopOrder(
      orderId: orderId,
      orderDate: DateTime.now(),
      totalAmount: cartTotal,
      items: List.from(cartItems),
      shippingAddress: _shippingAddress,
      paymentMethod: _selectedPaymentMethod,
      estimatedDelivery: estimatedDeliveryStr,
    );

    _orders.insert(0, order);
    _latestOrder = order;
    clearCart();
    
    return order;
  }
}
