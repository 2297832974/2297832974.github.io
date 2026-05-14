import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:token_buy/app/token_buy_app.dart';

void main() {
  testWidgets('shows restored app surface without frame controls', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TokenBuyApp());

    expect(find.text('SPAM USERNAMESS!!!\nGALAXY = 100K RBX'), findsNothing);
    expect(
      find.text('EDUCATIONAL PURPOSES ONLY\nTIKTOK THIS IS NOT A SCAM!'),
      findsNothing,
    );
    expect(find.text('Robux packages'), findsOneWidget);
    expect(find.byKey(const Key('open-send-dialog-button')), findsOneWidget);
    expect(find.text('Send Robux'), findsNothing);
    expect(find.text('Enter username'), findsNothing);
    expect(find.text('01'), findsNothing);
    expect(find.text('12'), findsNothing);
  });

  testWidgets('send dialog supports the app flow', (WidgetTester tester) async {
    await tester.pumpWidget(const TokenBuyApp());

    await tester.tap(find.byKey(const Key('open-send-dialog-button')));
    await tester.pumpAndSettle();

    expect(find.text('Search by username'), findsOneWidget);
    expect(find.text('My friends (8)'), findsOneWidget);
    expect(find.text('ktz'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('username-input')), 'ktz');
    await tester.pump();

    await tester.tap(find.byKey(const Key('friend-row-friend-ktz')));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('amount-input')), '5000');
    await tester.pump();

    await tester.tap(find.byKey(const Key('amount-next-button')));
    await tester.pump();

    expect(find.text('◎ 5,000'), findsOneWidget);
    expect(find.byKey(const Key('confirm-send-button')), findsOneWidget);
    expect(find.text('Exit'), findsOneWidget);
  });

  testWidgets(
    'search supports friend matches and enter-to-insert fallback results',
    (WidgetTester tester) async {
      await tester.pumpWidget(const TokenBuyApp());

      await tester.tap(find.byKey(const Key('open-send-dialog-button')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('username-input')), 'zzno');
      await tester.pump();

      expect(find.text('No users found'), findsOneWidget);
      expect(find.byKey(const Key('friend-row-search-zzno')), findsNothing);

      await tester.enterText(find.byKey(const Key('username-input')), 'zznone');
      await tester.pump();

      expect(find.byKey(const Key('friend-row-search-zznone')), findsNothing);
      expect(find.byKey(const Key('avatar-search-zznone-blank')), findsNothing);

      await tester.showKeyboard(find.byKey(const Key('username-input')));
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(find.byKey(const Key('friend-row-search-zznone')), findsOneWidget);
      final submittedRows = find.byWidgetPredicate(
        (widget) =>
            widget.key is ValueKey<String> &&
            (widget.key! as ValueKey<String>).value.startsWith('friend-row-'),
      );
      final submittedRowCount = submittedRows.evaluate().length;
      expect(submittedRowCount, greaterThanOrEqualTo(1));
      expect(submittedRowCount, lessThanOrEqualTo(20));

      final topMatchPosition = tester.getTopLeft(
        find.byKey(const Key('friend-row-search-zznone')),
      );
      for (final element in submittedRows.evaluate()) {
        final widget = element.widget;
        final key = widget.key;
        if (key is ValueKey<String> &&
            key.value == 'friend-row-search-zznone') {
          continue;
        }
        final position = tester.getTopLeft(find.byWidget(widget));
        expect(position.dy, greaterThanOrEqualTo(topMatchPosition.dy));
      }

      await tester.enterText(find.byKey(const Key('username-input')), 'sonic');
      await tester.pump();

      expect(find.text('SonicBacon'), findsOneWidget);
      expect(find.byKey(const Key('friend-row-search-sonic')), findsNothing);

      await tester.showKeyboard(find.byKey(const Key('username-input')));
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(find.byKey(const Key('friend-row-search-sonic')), findsOneWidget);
      expect(find.text('SonicBacon'), findsAtLeastNWidgets(1));

      await tester.tap(find.text('SonicBacon').first);
      await tester.pump();

      expect(find.text('SonicBacon'), findsOneWidget);
      expect(find.byKey(const Key('amount-input')), findsOneWidget);
    },
  );

  testWidgets('close button hides the send dialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TokenBuyApp());

    expect(find.text('Send Robux'), findsNothing);

    await tester.tap(find.byKey(const Key('open-send-dialog-button')));
    await tester.pumpAndSettle();

    expect(find.text('Send Robux'), findsOneWidget);
    await tester.tap(find.byKey(const Key('close-dialog-button')));
    await tester.pump();

    expect(find.text('Send Robux'), findsNothing);
    expect(find.text('Enjoy up to 25% more Robux'), findsOneWidget);
  });

  testWidgets('send shows success toast and returns to hidden home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TokenBuyApp());

    await tester.tap(
      find.byKey(const Key('home-balance-trigger')),
      buttons: kSecondaryMouseButton,
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('balance-input')), '10000');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('open-send-dialog-button')));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('dialog-balance-trigger')),
        matching: find.text('10,000'),
      ),
      findsOneWidget,
    );

    await tester.enterText(find.byKey(const Key('username-input')), 'mir');
    await tester.pump();
    await tester.tap(find.text('miriandogaru'));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('amount-input')), '5000');
    await tester.pump();
    await tester.tap(find.byKey(const Key('amount-next-button')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('confirm-send-button')));
    await tester.pump();

    expect(find.text('You sent 5,000 Robux'), findsOneWidget);
    expect(find.text('Send Robux'), findsNothing);

    await tester.pump(const Duration(milliseconds: 950));

    expect(find.text('Search by username'), findsNothing);
    expect(find.byKey(const Key('open-send-dialog-button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('open-send-dialog-button')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const Key('dialog-balance-trigger')),
        matching: find.text('5,000'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('home-balance-trigger')),
        matching: find.text('5,000'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('send is disabled when balance is insufficient', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TokenBuyApp());

    await tester.tap(
      find.byKey(const Key('home-balance-trigger')),
      buttons: kSecondaryMouseButton,
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('balance-input')), '100');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('open-send-dialog-button')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('username-input')), 'sonic');
    await tester.pump();
    await tester.tap(find.byKey(const Key('friend-row-friend-sonic')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('amount-input')), '500');
    await tester.pump();
    await tester.tap(find.byKey(const Key('amount-next-button')));
    await tester.pump();

    expect(find.text('Need 400 more Robux'), findsOneWidget);

    final sendContainer = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const Key('confirm-send-button')),
        matching: find.byType(Container),
      ),
    );
    final decoration = sendContainer.decoration! as BoxDecoration;
    expect(decoration.color, const Color(0xFFE1E3EA));
  });
}
