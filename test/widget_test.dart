import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  group('App widget', () {
    testWidgets('App sets OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen interaction tests', () {
    testWidgets('Initial screen shows correct widgets and text',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      
      // Check title and initial sandwich type
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Footlong'), findsNWidgets(2)); // One in display, one in button
      
      // Check quantity display
      expect(find.text('Quantity: 0'), findsOneWidget);
      
      // Verify all three sandwich buttons are present
      expect(find.widgetWithText(OutlinedButton, 'Club'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Footlong'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'BLT'), findsOneWidget);
    });

    testWidgets('Tapping add button increases quantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('Quantity: 1'), findsOneWidget);
    });

    testWidgets('Tapping remove button decreases quantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      
      // Add first to get to 1
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('Quantity: 1'), findsOneWidget);
      
      // Remove to get back to 0
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(find.text('Quantity: 0'), findsOneWidget);
    });

    testWidgets('Quantity does not go below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.text('Quantity: 0'), findsOneWidget);
      
      // Try to remove at 0
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(find.text('Quantity: 0'), findsOneWidget);
    });

    testWidgets('Quantity does not exceed maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      
      // Try to add beyond max (5)
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
        await tester.pump();
      }
      expect(find.text('Quantity: 5'), findsOneWidget);
    });

    testWidgets('Can switch between sandwich types using buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Initially shows Footlong
      expect(find.widgetWithText(ElevatedButton, 'Footlong'), findsOneWidget);

      // Tap next (BLT) button
      await tester.tap(find.widgetWithText(OutlinedButton, 'BLT'));
      await tester.pump();

      // Verify BLT is now the selected (elevated) button
      expect(find.widgetWithText(ElevatedButton, 'BLT'), findsOneWidget);
      expect(find.text('BLT'), findsNWidgets(2)); // Display and button

      // Tap next (Club) button
      await tester.tap(find.widgetWithText(OutlinedButton, 'Club'));
      await tester.pump();

      // Verify Club is now the selected button
      expect(find.widgetWithText(ElevatedButton, 'Club'), findsOneWidget);
      expect(find.text('Club'), findsNWidgets(2)); // Display and button
    });

    testWidgets('Slider changes sandwich selection', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Find the Slider widget
      final Finder slider = find.byType(Slider);
      expect(slider, findsOneWidget);

      // Initially at Footlong (index 0)
      expect(find.widgetWithText(ElevatedButton, 'Footlong'), findsOneWidget);

      // Slide to position 1 (BLT)
      await tester.drag(slider, const Offset(100.0, 0.0));
      await tester.pump();
      expect(find.widgetWithText(ElevatedButton, 'BLT'), findsOneWidget);

      // Slide to position 2 (Club)
      await tester.drag(slider, const Offset(100.0, 0.0));
      await tester.pump();
      expect(find.widgetWithText(ElevatedButton, 'Club'), findsOneWidget);
    });

    testWidgets('Sandwich size switch maintains quantity', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Add two sandwiches
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('2 white footlong sandwich(es): 🥪🥪'), findsOneWidget);

      // Switch to six-inch
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(find.text('2 white six-inch sandwich(es): 🥪🥪'), findsOneWidget);

      // Switch back to footlong
      await tester.tap(find.byType(Switch));
      await tester.pump();
      expect(find.text('2 white footlong sandwich(es): 🥪🥪'), findsOneWidget);
    });
  });

  group('OrderItemDisplay widget tests', () {
    testWidgets('Displays sandwich type and quantity correctly',
        (WidgetTester tester) async {
      const testWidget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: OrderItemDisplay(
              quantity: 3,
              itemType: 'BLT',
            ),
          ),
        ),
      );
      
      await tester.pumpWidget(testWidget);
      expect(find.text('BLT'), findsOneWidget);
      expect(find.text('Quantity: 3'), findsOneWidget);
    });
  });
}
