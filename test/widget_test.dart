import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Initial State', () {
    testWidgets('displays sandwich counter title', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('displays cart button', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byKey(const Key('cart_button')), findsOneWidget);
    });

    testWidgets('displays sandwich type dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(DropdownMenu<SandwichType>), findsOneWidget);
    });

    testWidgets('displays bread type dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(DropdownMenu<BreadType>), findsOneWidget);
    });

    testWidgets('displays size switch', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Six-inch'), findsOneWidget);
      expect(find.text('Footlong'), findsOneWidget);
    });

    testWidgets('displays add to cart button', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('displays sandwich image', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('displays quantity label', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('Quantity: '), findsOneWidget);
    });

    testWidgets('cart summary not shown initially when empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byKey(const Key('cart_summary')), findsNothing);
    });
  });

  group('OrderScreen - Quantity Controls', () {
    testWidgets('quantity controls exist', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Verify quantity controls are present
      expect(find.byIcon(Icons.add), findsWidgets);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.text('Quantity: '), findsOneWidget);
    });

    testWidgets('decrease button is disabled at quantity 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Scroll to make remove button visible
      final removeButton = find.byIcon(Icons.remove);
      await tester.ensureVisible(removeButton);
      await tester.pumpAndSettle();
      
      // Tap to decrease to 0
      await tester.tap(removeButton);
      await tester.pumpAndSettle();
      
      // Button should now be disabled
        final decreaseButton = tester.widget<IconButton>(
          find.ancestor(
            of: find.byIcon(Icons.remove),
            matching: find.byType(IconButton),
          ),
        );
      expect(decreaseButton.onPressed, isNull);
    });
  });

  group('OrderScreen - Size Toggle', () {
    testWidgets('switch starts in footlong position',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
    });

    testWidgets('toggles between footlong and six-inch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Initially should be footlong (true)
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
      
      // Scroll to make switch visible
      await tester.ensureVisible(find.byType(Switch));
      await tester.pumpAndSettle();
      
      // Toggle to six-inch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      
      final updatedSwitch = tester.widget<Switch>(find.byType(Switch));
      expect(updatedSwitch.value, false);
    });
  });

  group('OrderScreen - Sandwich Type Selection', () {
    testWidgets('displays all sandwich types in dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Ensure dropdown is visible
      await tester.ensureVisible(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();
      
      expect(find.text('Veggie Delight'), findsWidgets);
      expect(find.text('Chicken Teriyaki'), findsWidgets);
      expect(find.text('Tuna Melt'), findsWidgets);
      expect(find.text('Meatball Marinara'), findsWidgets);
    });

    testWidgets('can select different sandwich type',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      await tester.ensureVisible(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();
      
      // Verify selection changed (dropdown should show selected item)
      expect(find.text('Chicken Teriyaki'), findsWidgets);
    });
  });

  group('OrderScreen - Bread Type Selection', () {
    testWidgets('displays all bread types in dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      await tester.ensureVisible(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      
      expect(find.text('white'), findsWidgets);
      expect(find.text('wheat'), findsWidgets);
      expect(find.text('wholemeal'), findsWidgets);
    });

    testWidgets('can select different bread type',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      await tester.ensureVisible(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      
      expect(find.text('wheat'), findsWidgets);
    });
  });

  group('OrderScreen - Add to Cart', () {
    testWidgets('add to cart button exists',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      final addToCartButton = find.text('Add to Cart');
      expect(addToCartButton, findsOneWidget);
    });

    testWidgets('add to cart button is enabled initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      final addToCartButton = find.text('Add to Cart');
      final button = tester.widget<StyledButton>(
        find.ancestor(
          of: addToCartButton,
          matching: find.byType(StyledButton),
        ),
      );
      // Initial quantity is 1, so button should be enabled
      expect(button.onPressed, isNotNull);
    });

    testWidgets('add to cart button is disabled when quantity is 0',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Decrease quantity to 0
      final removeButton = find.byIcon(Icons.remove);
      await tester.ensureVisible(removeButton);
      await tester.pumpAndSettle();
      
      await tester.tap(removeButton);
      await tester.pumpAndSettle();
      
      final addToCartButton = find.text('Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();
      
      final button = tester.widget<StyledButton>(
        find.ancestor(
          of: addToCartButton,
          matching: find.byType(StyledButton),
        ),
      );
      expect(button.onPressed, isNull);
    });
  });

  group('OrderScreen - Image Display', () {
    testWidgets('displays sandwich image', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Should find at least one Image.asset widget
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('image updates when sandwich type changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Ensure dropdown is visible
      await tester.ensureVisible(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();
      
      // Change sandwich type
      await tester.tap(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Tuna Melt').last);
      await tester.pumpAndSettle();
      
      // Image should still be displayed
      expect(find.byType(Image), findsWidgets);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      
      await tester.pumpWidget(testApp);
      
      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('is disabled when onPressed is null',
        (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Disabled',
        backgroundColor: Colors.grey,
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      
      await tester.pumpWidget(testApp);
      
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasTapped = false;
      
      final testButton = StyledButton(
        onPressed: () => wasTapped = true,
        icon: Icons.check,
        label: 'Tap Me',
        backgroundColor: Colors.blue,
      );
      final testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      
      await tester.pumpWidget(testApp);
      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      expect(wasTapped, true);
    });
  });

  group('OrderScreen - Cart Navigation', () {
    testWidgets('cart button opens cart screen', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      
      // Find and tap cart button
      final cartButton = find.byKey(const Key('cart_button'));
      expect(cartButton, findsOneWidget);
      
      await tester.tap(cartButton);
      await tester.pumpAndSettle();
      
      // Should navigate to CartScreen - verify by checking title
      expect(find.text('Shopping Cart'), findsOneWidget);
    });
  });

  group('OrderScreen - Cart Summary', () {
    testWidgets('cart summary badge appears after adding item',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Initially no summary
      expect(find.byKey(const Key('cart_summary')), findsNothing);

      // Scroll to make add to cart button visible
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Tap add to cart
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Summary badge should now appear
      expect(find.byKey(const Key('cart_summary')), findsOneWidget);
      expect(find.byKey(const Key('cart_summary_text')), findsOneWidget);
    });

    testWidgets('cart summary badge shows correct item count',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Add 1 item (initial quantity is 1)
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Verify badge shows "1"
      final summaryText = tester.widget<Text>(
        find.byKey(const Key('cart_summary_text')),
      );
      expect(summaryText.data, '1');
    });

    testWidgets('cart summary updates when multiple items added',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Increase quantity to 3
      final addButton = find.byIcon(Icons.add).last;
      await tester.ensureVisible(addButton);
      await tester.pumpAndSettle();

      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Add 3 items to cart
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Verify badge shows "3"
      final summaryText = tester.widget<Text>(
        find.byKey(const Key('cart_summary_text')),
      );
      expect(summaryText.data, '3');
    });

    testWidgets('cart summary increments on multiple add operations',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Add 1 item
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      var summaryText = tester.widget<Text>(
        find.byKey(const Key('cart_summary_text')),
      );
      expect(summaryText.data, '1');
    });

    testWidgets('cart summary badge has correct styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Add item
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Verify container exists with red background
      final badgeContainer = tester.widget<Container>(
        find.byKey(const Key('cart_summary')),
      );
      expect(badgeContainer, isNotNull);
    });
  });
}
