import 'package:flutter_test/flutter_test.dart';
import 'package:token_buy/app/token_buy_app.dart';

void main() {
  testWidgets('workspace shows flow plan and reference frames', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TokenBuyApp());

    expect(find.text('Token Buy Flow Workspace'), findsOneWidget);
    expect(find.text('Build Sequence'), findsOneWidget);
    expect(find.text('Reference Frames'), findsOneWidget);
    expect(find.text('Search Entry'), findsOneWidget);
    expect(find.text('Confirmation'), findsOneWidget);
  });

  testWidgets('stage switching updates current focus components', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TokenBuyApp());

    expect(find.text('Pinned modal card'), findsOneWidget);

    await tester.ensureVisible(find.text('Amount Input'));
    await tester.tap(find.text('Amount Input'));
    await tester.pump();

    expect(find.text('Quick amount chips'), findsOneWidget);
    expect(find.text('Pinned modal card'), findsNothing);
  });
}
