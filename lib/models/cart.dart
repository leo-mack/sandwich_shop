import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// Represents a single line item in the cart: a sandwich + quantity.
class CartItem {
  final Sandwich sandwich;
  int quantity;
  final PricingRepository _pricingRepository;

  CartItem({
    required this.sandwich,
    required this.quantity,
    PricingRepository? pricingRepository,
  }) : _pricingRepository = pricingRepository ?? PricingRepository();

  /// Calculate the total price for this item using PricingRepository.
  double get totalPrice => _pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );

  /// Create a copy with modified quantity.
  CartItem copyWith({int? quantity}) => CartItem(
        sandwich: sandwich,
        quantity: quantity ?? this.quantity,
        pricingRepository: _pricingRepository,
      );
}

/// Cart manages a collection of sandwich items with add, update, remove, and total.
class Cart {
  final List<CartItem> _items = [];

  /// Get a copy of current items.
  List<CartItem> get items => List.unmodifiable(_items);

  /// Get total number of sandwiches in cart.
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Get total price of all items.
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Add a sandwich to the cart (or increment if already present).
  void addSandwich(Sandwich sandwich, int quantity) {
    if (quantity <= 0) return;

    final existingIndex = _items.indexWhere(
      (item) =>
          item.sandwich.type == sandwich.type &&
          item.sandwich.isFootlong == sandwich.isFootlong &&
          item.sandwich.breadType == sandwich.breadType,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Alias for addSandwich for convenience.
  void add(Sandwich sandwich, {int quantity = 1}) {
    addSandwich(sandwich, quantity);
  }

  /// Update quantity of an item at the given index.
  void updateQuantity(int index, int quantity) {
    if (index < 0 || index >= _items.length) return;
    if (quantity <= 0) {
      removeAt(index);
    } else {
      _items[index].quantity = quantity;
    }
  }

  /// Remove item at the given index.
  void removeAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  /// Clear all items from the cart.
  void clear() => _items.clear();

  /// Check if cart is empty.
  bool get isEmpty => _items.isEmpty;
}
