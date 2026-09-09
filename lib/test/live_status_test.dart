import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yatra_saathi/live_status_screen.dart'; // Apna actual package/import path check kar lein

void main() {
  group('Live Train Status Core Module Tests', () {

    testWidgets('Search screen renders input field and search button', (WidgetTester tester) async {
      // Build LiveStatusSearchScreen
      await tester.pumpWidget(
        const MaterialApp(
          home: LiveStatusSearchScreen(),
        ),
      );

      // Verify title and input field exist
      expect(find.text('Live Train Status'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Check Live Status'), findsOneWidget);
    });

    testWidgets('Entering invalid train number 0000 triggers Train Not Found error state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LiveStatusDetailScreen(
            trainNumber: '0000',
            journeyDate: 'Today (Thu, 4 Sep)',
          ),
        ),
      );

      // Verify error state view is displayed
      expect(find.text('Train Not Found'), findsOneWidget);
      expect(find.text('Go Back'), findsOneWidget);
    });

    testWidgets('Entering simulated API failure code 9999 triggers API Unavailable error state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LiveStatusDetailScreen(
            trainNumber: '9999',
            journeyDate: 'Today (Thu, 4 Sep)',
          ),
        ),
      );

      // Verify API unavailable error view and retry button
      expect(find.text('API Unavailable'), findsOneWidget);
      expect(find.text('Retry Connection'), findsOneWidget);
    });

    testWidgets('Valid train number 12951 loads timeline, ETA, and distance details', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LiveStatusDetailScreen(
            trainNumber: '12951',
            journeyDate: 'Today (Thu, 4 Sep)',
          ),
        ),
      );

      // Verify header and timeline content load successfully
      expect(find.text('12951 • Rajdhani Express'), findsOneWidget);
      expect(find.text('Route Timeline & ETA'), findsOneWidget);
      expect(find.text('New Delhi (NDLS)'), findsOneWidget);
      expect(find.text('Mumbai Central (BCT)'), findsOneWidget);
    });
  });
}