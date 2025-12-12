import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('CartItem', () {
    late PricingRepository pricingRepository;

    setUp(() {
      pricingRepository = PricingRepository();
    });

    test('initializes with correct sandwich and quantity', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final item = CartItem(
        sandwich: sandwich,
        quantity: 2,
        pricingRepository: pricingRepository,
      );

      expect(item.sandwich, sandwich);
      expect(item.quantity, 2);
    });

    test('calculates totalPrice correctly for footlong', () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.wheat,
      );
      final item = CartItem(
        sandwich: sandwich,
        quantity: 3,
        pricingRepository: pricingRepository,
      );

      // Footlong = 11.00 per item, 3 * 11.00 = 33.00
      expect(item.totalPrice, closeTo(33.0, 0.01));
    });

    test('calculates totalPrice correctly for six-inch', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wholemeal,
      );
      final item = CartItem(
        sandwich: sandwich,
        quantity: 2,
        pricingRepository: pricingRepository,
      );

      // Six-inch = 7.00 per item, 2 * 7.00 = 14.00
      expect(item.totalPrice, closeTo(14.0, 0.01));
    });

    test('copyWith creates new CartItem with updated quantity', () {
      final sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final item = CartItem(
        sandwich: sandwich,
        quantity: 1,
        pricingRepository: pricingRepository,
      );

      final updated = item.copyWith(quantity: 5);

      expect(updated.quantity, 5);
      expect(updated.sandwich, sandwich);
      expect(item.quantity, 1);
    });

    test('copyWith preserves quantity if not provided', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      final item = CartItem(
        sandwich: sandwich,
        quantity: 3,
        pricingRepository: pricingRepository,
      );

      final copiedItem = item.copyWith();

      expect(copiedItem.quantity, 3);
    });
  });

  group('Cart', () {
    late Cart cart;

    setUp(() {
      cart = Cart();
    });

    test('initializes with empty items', () {
      expect(cart.items, isEmpty);
      expect(cart.totalQuantity, 0);
      expect(cart.totalPrice, 0.0);
      expect(cart.isEmpty, true);
    });

    test('addSandwich adds item to cart', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      cart.addSandwich(sandwich, 2);

      expect(cart.items.length, 1);
      expect(cart.items[0].sandwich, sandwich);
      expect(cart.items[0].quantity, 2);
    });

    test('addSandwich increments quantity if sandwich already exists', () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.addSandwich(sandwich, 2);
      cart.addSandwich(sandwich, 3);

      expect(cart.items.length, 1);
      expect(cart.items[0].quantity, 5);
    });

    test('addSandwich ignores non-positive quantities', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: true,
        breadType: BreadType.white,
      );

      cart.addSandwich(sandwich, 0);
      cart.addSandwich(sandwich, -1);

      expect(cart.items, isEmpty);
    });

    test('totalQuantity sums all item quantities', () {
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.addSandwich(sandwich1, 3);
      cart.addSandwich(sandwich2, 2);

      expect(cart.totalQuantity, 5);
    });

    test('totalPrice sums all item prices', () {
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true, // 11.00 each
        breadType: BreadType.white,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false, // 7.00 each
        breadType: BreadType.wheat,
      );

      cart.addSandwich(sandwich1, 2); // 2 * 11 = 22
      cart.addSandwich(sandwich2, 1); // 1 * 7 = 7
      // Total = 29

      expect(cart.totalPrice, closeTo(29.0, 0.01));
    });

    test('updateQuantity changes quantity of item at index', () {
      final sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.white,
      );

      cart.addSandwich(sandwich, 2);
      cart.updateQuantity(0, 5);

      expect(cart.items[0].quantity, 5);
    });

    test('updateQuantity removes item if quantity <= 0', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );

      cart.addSandwich(sandwich, 2);
      cart.updateQuantity(0, 0);

      expect(cart.items, isEmpty);
    });

    test('updateQuantity ignores invalid index', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      cart.addSandwich(sandwich, 2);
      cart.updateQuantity(10, 5); // Invalid index

      expect(cart.items[0].quantity, 2); // Unchanged
    });

    test('removeAt removes item at valid index', () {
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.addSandwich(sandwich1, 1);
      cart.addSandwich(sandwich2, 1);
      cart.removeAt(0);

      expect(cart.items.length, 1);
      expect(cart.items[0].sandwich.type, SandwichType.chickenTeriyaki);
    });

    test('removeAt ignores invalid index', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      cart.addSandwich(sandwich, 1);
      cart.removeAt(10); // Invalid index

      expect(cart.items.length, 1); // Unchanged
    });

    test('clear removes all items', () {
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );

      cart.addSandwich(sandwich1, 2);
      cart.addSandwich(sandwich2, 1);
      cart.clear();

      expect(cart.items, isEmpty);
      expect(cart.totalQuantity, 0);
      expect(cart.totalPrice, 0.0);
    });

    test('items returns unmodifiable list', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      cart.addSandwich(sandwich, 1);
      final items = cart.items;

      expect(() => items.add(CartItem(sandwich: sandwich, quantity: 1)),
          throwsUnsupportedError);
    });

    test('different sandwich configurations are stored separately', () {
      final sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final sandwich2 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false, // Different size
        breadType: BreadType.white,
      );
      final sandwich3 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.wheat, // Different bread
      );

      cart.addSandwich(sandwich1, 1);
      cart.addSandwich(sandwich2, 1);
      cart.addSandwich(sandwich3, 1);

      expect(cart.items.length, 3);
    });
  });
}
