import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finalprojecttracker/main.dart';
import 'package:finalprojecttracker/screens/splash_screen.dart';

void main() {
  testWidgets('App loads and shows splash screen', (WidgetTester tester) async {
    // Build the app with showOnboarding = false to go directly to SplashScreen
    await tester.pumpWidget(const MyApp(showOnboarding: false));

    // Wait for animations and transitions to complete
    await tester.pumpAndSettle();

    // Check if SplashScreen is displayed
    expect(find.byType(SplashScreen), findsOneWidget);

    // Optional: Check for a welcome message (adjust text to match your actual UI)
    expect(find.textContaining('Let’s Get Started'), findsOneWidget);
  });
}
