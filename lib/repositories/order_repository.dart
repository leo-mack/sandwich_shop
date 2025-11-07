class OrderRepository {
  int _quantity = 0;
  final int maxQuantity;

  OrderRepository({required this.maxQuantity});

  int get quantity => _quantity;

  bool get canIncrement => _quantity < maxQuantity;
  bool get canDecrement => _quantity > 0;

  void increment() {
    if (canIncrement) {
      _quantity++;
    }
  }

  void decrement() {
    if (canDecrement) {
      _quantity--;
    }
  }
}


class PricingRepository {
  const PricingRepository();

  double calculateTotal({required int quantity, required bool isFootlong}) {
    if (quantity <= 0) return 0.0;
    final double unitPrice = isFootlong ? 11.0 : 7.0;
    return unitPrice * quantity;
  }
}