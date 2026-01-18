import 'package:flutter_test/flutter_test.dart';
import 'package:erotic_dice_app/main.dart';
import 'package:erotic_dice_app/models/dice.dart';

void main() {
  group('Dice Model Tests', () {
    test('Dice roll returns a value from options', () {
      final dice = Dice(
        title: 'Test',
        options: ['Option1', 'Option2', 'Option3'],
      );

      final result = dice.roll();
      expect(dice.options.contains(result), true);
    });

    test('Dice title can be set', () {
      final dice = Dice(
        title: 'Initial',
        options: ['Option1'],
      );

      expect(dice.title, 'Initial');
      dice.title = 'Updated';
      expect(dice.title, 'Updated');
    });
  });

  group('Widget Tests', () {
    testWidgets('App loads with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const EroticDiceApp());
      expect(find.text('Erotic Dice'), findsOneWidget);
    });

    testWidgets('Roll button is present', (WidgetTester tester) async {
      await tester.pumpWidget(const EroticDiceApp());
      expect(find.text('Roll Dice'), findsOneWidget);
    });

    testWidgets('Default number of dice is 3', (WidgetTester tester) async {
      await tester.pumpWidget(const EroticDiceApp());
      
      // Check that all three default dice titles are present
      expect(find.text('Actions'), findsOneWidget);
      expect(find.text('Body Area'), findsOneWidget);
      expect(find.text('Time'), findsOneWidget);
    });

    testWidgets('Dice can be rolled', (WidgetTester tester) async {
      await tester.pumpWidget(const EroticDiceApp());
      
      // Tap the roll button
      await tester.tap(find.text('Roll Dice'));
      await tester.pump();
      
      // Check that Result section appears
      expect(find.text('Result'), findsOneWidget);
    });

    testWidgets('Number of dice can be changed', (WidgetTester tester) async {
      await tester.pumpWidget(const EroticDiceApp());
      
      // Find and tap the "1" choice chip
      await tester.tap(find.text('1'));
      await tester.pump();
      
      // Roll the dice
      await tester.tap(find.text('Roll Dice'));
      await tester.pump();
      
      // After rolling with 1 dice, only one result should be displayed
      // The result card should be visible
      expect(find.text('Result'), findsOneWidget);
    });
  });
}
