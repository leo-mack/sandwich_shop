import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';

void main() {
  group('PricingRepository', () {
    test('zero quantity returns 0.0', () {
      const repo = PricingRepository();
      final total = repo.calculateTotal(quantity: 0, isFootlong: true);
      expect(total, 0.0);
    });

    test('six-inch pricing uses six-inch unit price', () {
      const repo = PricingRepository();
      final total = repo.calculateTotal(quantity: 2, isFootlong: false);
      expect(total, 14.0);
    });

    test('footlong pricing uses footlong unit price', () {
      const repo = PricingRepository();
      final total = repo.calculateTotal(quantity: 3, isFootlong: true);
      expect(total, 33.0);
    });
  });
}
