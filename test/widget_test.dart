import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('Howzy app boots into splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: HowzyApp()));

    expect(find.text('howzy'), findsOneWidget);
    expect(find.text('GROW BIG EARN BIG'), findsOneWidget);

    // Pump in steps so each call fires timers created during the previous frame.
    // Timer inventory (all durations from T=0 unless noted):
    //   AppRoot 3s nav timer          → fires at T=3s
    //   SplashScreen 800ms / 1600ms   → fires at T=0.8s / T=1.6s
    //   FirebaseSetupBanner 6s        → fires at T=6s (shown during splash too)
    //   _GlowBlob delay=0ms / 800ms  → created at T≈3s, fire at T≈3s / T≈3.8s
    await tester.pump(const Duration(milliseconds: 50));   // T=0.05s  – 0ms timers
    await tester.pump(const Duration(milliseconds: 3000)); // T=3.05s  – 3s nav timer fires
    await tester.pump(const Duration(milliseconds: 50));   // T=3.1s   – GlowBlob 0ms timers
    await tester.pump(const Duration(milliseconds: 900));  // T=4.0s   – GlowBlob 800ms timers
    await tester.pump(const Duration(seconds: 3));         // T=7.0s   – 6s banner timer fires
    await tester.pump(const Duration(milliseconds: 50));   // T=7.05s  – banner 0ms cascades
    await tester.pump(const Duration(milliseconds: 900));  // T=7.95s  – banner 800ms cascades

    expect(find.text('Login'), findsOneWidget);
  });
}
