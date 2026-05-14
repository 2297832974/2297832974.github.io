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
    await tester.pump();

    expect(find.text('Enter username'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('username-input')), 'gxyan');
    await tester.pump();

    await tester.tap(find.text('Sauveur2deCAPYBARAS'));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('amount-input')), '5000');
    await tester.pump();

    await tester.tap(find.byKey(const Key('amount-next-button')));
    await tester.pump();

    expect(find.text('◎ 5,000'), findsOneWidget);
    expect(find.byKey(const Key('confirm-send-button')), findsOneWidget);
    expect(find.text('Exit'), findsOneWidget);
  });

  testWidgets('search supports no results and alternate users', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TokenBuyApp());

    await tester.tap(find.byKey(const Key('open-send-dialog-button')));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('username-input')), 'zznone');
    await tester.pump();

    expect(find.text('No users found'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('username-input')), 'sonic');
    await tester.pump();

    expect(find.text('SonicBacon'), findsOneWidget);

    await tester.tap(find.text('SonicBacon'));
    await tester.pump();

    expect(find.text('SonicBacon'), findsOneWidget);
    expect(find.byKey(const Key('amount-input')), findsOneWidget);
  });

  testWidgets('close button hides the send dialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TokenBuyApp());

    expect(find.text('Send Robux'), findsNothing);

    await tester.tap(find.byKey(const Key('open-send-dialog-button')));
    await tester.pump();

    expect(find.text('Send Robux'), findsOneWidget);
    await tester.tap(find.byKey(const Key('close-dialog-button')));
    await tester.pump();

    expect(find.text('Send Robux'), findsNothing);
    expect(find.text('Enjoy up to 25% more\nRobux'), findsOneWidget);
  });

  testWidgets('send shows success toast and returns to hidden home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TokenBuyApp());

    await tester.tap(find.byKey(const Key('open-send-dialog-button')));
    await tester.pump();

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

    expect(find.text('Enter username'), findsNothing);
    expect(find.byKey(const Key('open-send-dialog-button')), findsOneWidget);
  });
}
