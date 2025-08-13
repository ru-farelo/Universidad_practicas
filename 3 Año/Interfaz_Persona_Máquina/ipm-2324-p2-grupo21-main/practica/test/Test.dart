import 'package:fcs_stub/favoritos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fcs_stub/conversions.dart';
import 'package:provider/provider.dart';





Future<void> main() async {

  group('Widget Tests', () {
    // Widget test for the Conversion widget
    testWidgets('Test Conversion Widget', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ChangeNotifierProvider<Conversion>(
          create: (_) => Conversion(),
          child: MaterialApp(
            home: Material(
              child: Builder(
                builder: (context) =>
                    Column(
                      children: [
                        Text(Provider
                            .of<Conversion>(context)
                            .currentOrigin),
                        Text(Provider
                            .of<Conversion>(context)
                            .conversions[0].to),
                        // Add more widget tests as needed
                      ],
                    ),
              ),
            ),
          ),
        ),
      );

      // Example widget tests
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('USD'), findsOneWidget);
    });


    // Widget test for the Favoritos widget
    testWidgets('Test Favoritos Widget', (WidgetTester tester) async {
      // final prefs = TestSharedPreferences();
      // Initialize Favoritos with some data for testing
      final Favoritos favoritosProvider = Favoritos( );
      favoritosProvider.addFavorites(100, 'USD', 'EUR', 85.0); // Add a sample favorite

      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ChangeNotifierProvider<Favoritos>(
          create: (_) => favoritosProvider,
          child: MaterialApp(
            home: Material(
              child: Builder(
                builder: (context) {
                  // Get the favoritos list from the provider
                  final favoritos = Provider.of<Favoritos>(context).favoritos;

                  // Print the favoritos for debugging
                  print('Favoritos: $favoritos');

                  // Check if favoritos is empty and handle the case
                  if (favoritos.isEmpty) {
                    return Container(); // Return an empty container or handle the case when favoritos is empty.
                  }

                  // Print the details of the first favorito for debugging
                  print('From: ${favoritos[0].from}');
                  print('To: ${favoritos[0].to}');

                  // Build the widget tree
                  return Column(
                    children: [
                      Text(favoritos[0].from),
                      Text(favoritos[0].to),
                      // Add more widget tests as needed
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Example widget tests
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('USD'), findsOneWidget);
    });
  });






}