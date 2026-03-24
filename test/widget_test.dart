import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('Howzy app boots into splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const HowzyApp());

    expect(find.text('howzy'), findsOneWidget);
    expect(find.text('GROW BIG EARN BIG'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Login'), findsOneWidget);
  });
}
