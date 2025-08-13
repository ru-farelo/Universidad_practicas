import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fcs_stub/main.dart';

import 'package:fcs_stub/favoritos.dart';
import 'package:fcs_stub/conversions.dart';
import 'package:provider/provider.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Test Casos de Uso de la API , Conversion , Añadir a favoritos y borrar la moneda de favoritos' , ( ) {

    testWidgets(
      'Test Realizar una conversión',
          (WidgetTester tester) async {
        // Configurar el widget con los proveedores necesarios
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => Conversion()),
              ChangeNotifierProvider(create: (_) => Favoritos()),
            ],
            child: const ResponsiveApp(),
          ),
        );

        // Encontrar el TextFormField y asegurarse de que esté presente
        final textFormField = find.byType(TextFormField);
        expect(textFormField, findsOneWidget);

        // Ingresar el monto '1' en el TextFormField
        await tester.enterText(textFormField, '1');

        // Verificar que el menú desplegable "De" esté presente
        final dropdownFrom = find.byKey(const ValueKey('dropdownFrom'));
        expect(dropdownFrom, findsOneWidget);

        // Abrir el menú desplegable "De"
        await tester.ensureVisible(dropdownFrom);
        await tester.tap(dropdownFrom, warnIfMissed: false);
        await tester.pumpAndSettle();

        await tester.pump(const Duration(milliseconds: 1500)); // Agregar retardo

        // Seleccionar la moneda "JPY" en el menú desplegable "De"
        await tester.tap(find
            .text('EUR')
            .last);
        await tester.pumpAndSettle();

        // Verificar que el menú desplegable "A" esté presente
        final dropdownTo = find.byKey(const ValueKey('dropdownTo'));
        expect(dropdownTo, findsOneWidget);

        // Abrir el menú desplegable "A"
        await tester.ensureVisible(dropdownTo);
        await tester.tap(dropdownTo, warnIfMissed: false);
        await tester.pumpAndSettle();

        await tester.pump(const Duration(milliseconds: 1500)); // Agregar retardo

        // Seleccionar la moneda "EUR" en el menú desplegable "A"
        await tester.tap(find
            .text('JPY')
            .last);
        await tester.pumpAndSettle();

        // Encontrar el botón "Convertir" y asegurarse de que esté presente
        final button = find.byKey(const Key('convertButton'));
        expect(button, findsOneWidget);

        // Presionar el botón "Convertir"
        await tester.tap(button);
        await tester.pumpAndSettle(const Duration(milliseconds: 2500));

        //Comprobar  se a cantidade convertida é a que debería ser
        expect(find.text('1 EUR = 158.59 JPY'), findsOneWidget);
        await tester.pumpAndSettle(const Duration(milliseconds: 1500));

          },
    );


    testWidgets(
      'Test Casos de uso Añadir a favoritos',
          (WidgetTester tester) async {
        // Configurar el widget con los proveedores necesarios
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => Conversion()),
              ChangeNotifierProvider(create: (_) => Favoritos()),
            ],
            child: const ResponsiveApp(),
          ),
        );

        // Encontrar el TextFormField y asegurarse de que esté presente
        final textFormField = find.byType(TextFormField);
        expect(textFormField, findsOneWidget);

        // Ingresar el monto '1' en el TextFormField
        await tester.enterText(textFormField, '1');

        // Verificar que el menú desplegable "De" esté presente
        final dropdownFrom = find.byKey(const ValueKey('dropdownFrom'));
        expect(dropdownFrom, findsOneWidget);

        // Abrir el menú desplegable "De"
        await tester.ensureVisible(dropdownFrom);
        await tester.tap(dropdownFrom, warnIfMissed: false);
        await tester.pumpAndSettle();

        await tester.pump(const Duration(milliseconds: 1500)); // Agregar retardo

        // Seleccionar la moneda "EUR" en el menú desplegable "De"
        await tester.tap(find
            .text('EUR')
            .last);
        await tester.pumpAndSettle();

        // Verificar que el menú desplegable "A" esté presente
        final dropdownTo = find.byKey(const ValueKey('dropdownTo'));
        expect(dropdownTo, findsOneWidget);

        // Abrir el menú desplegable "A"
        await tester.ensureVisible(dropdownTo);
        await tester.tap(dropdownTo, warnIfMissed: false);
        await tester.pumpAndSettle();

        await tester.pump(const Duration(milliseconds: 1500)); // Agregar retardo

        // Seleccionar la moneda "JPY" en el menú desplegable "A"
        await tester.tap(find
            .text('USD')
            .last);
        await tester.pumpAndSettle();

        // Encontrar el botón "Convertir" y asegurarse de que esté presente
        final button = find.byKey(const Key('convertButton'));
        expect(button, findsOneWidget);

        // Presionar el botón "Convertir"
        await tester.tap(button);
        await tester.pumpAndSettle(const Duration(milliseconds: 2500));

        // Encontrar el botón "Agregar a favoritos" y asegurarse de que esté presente
        final buttonFav = find.byIcon(Icons.favorite);
        expect(buttonFav, findsOneWidget);

        // Presionar el botón "Agregar a favoritos"
        await tester.tap(buttonFav);
        await tester.pumpAndSettle(const Duration(milliseconds: 2500));

        //Presionar el boton de favoritos en navigation bar
        final buttonFavNav = find.byIcon(Icons.monetization_on);
        if (buttonFavNav.evaluate().isNotEmpty) {
          expect(buttonFavNav, findsOneWidget);
          await tester.tap(buttonFavNav);
          await tester.pumpAndSettle(const Duration(milliseconds: 2500));

          //Comprobar que se añadio la moneda a favoritos

          expect(find.text('1 EUR = 1.06 USD'), buttonFav);
          await tester.pumpAndSettle(const Duration(milliseconds: 2500));
        }

      },
    );

    testWidgets(
      'Test Casos de uso Borrar de favoritos',
          (WidgetTester tester) async {
        // Configurar el widget con los proveedores necesarios
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => Conversion()),
              ChangeNotifierProvider(create: (_) => Favoritos()),
            ],
            child: const ResponsiveApp(),
          ),
        );

        // Encontrar el TextFormField y asegurarse de que esté presente
        final textFormField = find.byType(TextFormField);
        expect(textFormField, findsOneWidget);

        // Ingresar el monto '1' en el TextFormField
        await tester.enterText(textFormField, '1');

        // Verificar que el menú desplegable "De" esté presente
        final dropdownFrom = find.byKey(const ValueKey('dropdownFrom'));
        expect(dropdownFrom, findsOneWidget);

        // Abrir el menú desplegable "De"
        await tester.ensureVisible(dropdownFrom);
        await tester.tap(dropdownFrom, warnIfMissed: false);
        await tester.pumpAndSettle();

        await tester.pump(const Duration(milliseconds: 1500)); // Agregar retardo

        // Seleccionar la moneda "JPY" en el menú desplegable "De"
        await tester.tap(find
            .text('EUR')
            .last);
        await tester.pumpAndSettle();

        // Verificar que el menú desplegable "A" esté presente
        final dropdownTo = find.byKey(const ValueKey('dropdownTo'));
        expect(dropdownTo, findsOneWidget);

        // Abrir el menú desplegable "A"
        await tester.ensureVisible(dropdownTo);
        await tester.tap(dropdownTo, warnIfMissed: false);
        await tester.pumpAndSettle();

        await tester.pump(const Duration(milliseconds: 1500)); // Agregar retardo

        // Seleccionar la moneda "EUR" en el menú desplegable "A"
        await tester.tap(find
            .text('JPY')
            .last);
        await tester.pumpAndSettle();

        // Encontrar el botón "Convertir" y asegurarse de que esté presente
        final button = find.byKey(const Key('convertButton'));
        expect(button, findsOneWidget);

        // Presionar el botón "Convertir"
        await tester.tap(button);
        await tester.pumpAndSettle(const Duration(milliseconds: 2500));

        // Encontrar el botón "Agregar a favoritos" y asegurarse de que esté presente
        final buttonFav = find.byIcon(Icons.favorite);
        expect(buttonFav, findsOneWidget);

        // Presionar el botón "Agregar a favoritos"
        await tester.tap(buttonFav);
        await tester.pumpAndSettle(const Duration(milliseconds: 2500));

        //Presionar el boton de favoritos en navigation bar
        final buttonFavNav = find.byIcon(Icons.monetization_on);
        if (buttonFavNav.evaluate().isNotEmpty) {
          expect(buttonFavNav, findsOneWidget);
          await tester.tap(buttonFavNav);
          await tester.pumpAndSettle(const Duration(milliseconds: 2500));
        }

        // Encontrar el botón "Borrar" y asegurarse de que esté presente pero solo el de USD
        final buttonDelete = find.byIcon(Icons.delete).last;
        expect(buttonDelete, findsOneWidget);

        // Presionar el botón "Borrar" solo de la moneda JPY
        await tester.tap(buttonDelete.last);
        await tester.pumpAndSettle(const Duration(milliseconds: 2500));

        // Obtener la instancia de Favoritos
        final favoritos = Provider.of<Favoritos>(tester.element(find.byType(ResponsiveApp)), listen: false);

        // Crear la información de la conversión para la moneda que deseas verificar
        final conversionInfo = FavoritosInfo(1, 'EUR', 'JPY', 158.59);

        // Verificar que la moneda deseada ya no está en la lista de favoritos
        expect(favoritos.isFavorite(conversionInfo), isFalse);
      },
    );

    testWidgets(
        'Test origen igual a destino',
            (WidgetTester tester) async {
          // Configurar el widget con los proveedores necesarios
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => Conversion()),
                ChangeNotifierProvider(create: (_) => Favoritos()),
              ],
              child: const ResponsiveApp(),
            ),
          );

          // Verificar que el menú desplegable "De" esté presente
          final dropdownFrom = find.byKey(const ValueKey('dropdownFrom'));
          expect(dropdownFrom, findsOneWidget);

          // Abrir el menú desplegable "De"
          await tester.ensureVisible(dropdownFrom);
          await tester.tap(dropdownFrom, warnIfMissed: false);
          await tester.pumpAndSettle();

          await tester.pump(const Duration(milliseconds: 1500)); // Agregar retardo

          // Seleccionar la moneda "JPY" en el menú desplegable "De"
          await tester.tap(find
              .text('JPY')
              .last);
          await tester.pumpAndSettle();

          // Verificar que el menú desplegable "A" esté presente
          final dropdownTo = find.byKey(const ValueKey('dropdownTo'));
          expect(dropdownTo, findsOneWidget);

          // Abrir el menú desplegable "A"
          await tester.ensureVisible(dropdownTo);
          await tester.tap(dropdownTo, warnIfMissed: false);
          await tester.pumpAndSettle();

          await tester.pump(const Duration(milliseconds: 1500)); // Agregar retardo

          // Seleccionar la moneda "EUR" en el menú desplegable "A"
          await tester.tap(find
              .text('JPY')
              .last);
          await tester.pumpAndSettle();

          await tester.pump(const Duration(milliseconds: 2500));


          // Comprobar que se muestra el mensaje de error
          expect(find.text('Origin must be different than destiny'), findsOneWidget);
          await tester.pumpAndSettle(const Duration(milliseconds: 2500));

        });

    testWidgets(
        'Test la moneda ya esta en favoritos',
            (WidgetTester tester) async {
          // Configurar el widget con los proveedores necesarios
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => Conversion()),
                ChangeNotifierProvider(create: (_) => Favoritos()),
              ],
              child: const ResponsiveApp(),
            ),
          );

          // Encontrar el TextFormField y asegurarse de que esté presente
          final textFormField = find.byType(TextFormField);
          expect(textFormField, findsOneWidget);

          // Ingresar el monto '1' en el TextFormField
          await tester.enterText(textFormField, '1');

          // Verificar que el menú desplegable "De" esté presente
          final dropdownFrom = find.byKey(const ValueKey('dropdownFrom'));
          expect(dropdownFrom, findsOneWidget);

          // Abrir el menú desplegable "De"
          await tester.ensureVisible(dropdownFrom);
          await tester.tap(dropdownFrom, warnIfMissed: false);
          await tester.pumpAndSettle();

          await tester.pump(const Duration(milliseconds: 1500)); // Agregar retardo

          // Seleccionar la moneda "MXN" en el menú desplegable "De"
          await tester.tap(find
              .text('JPY')
              .last);
          await tester.pumpAndSettle();

          // Verificar que el menú desplegable "A" esté presente
          final dropdownTo = find.byKey(const ValueKey('dropdownTo'));
          expect(dropdownTo, findsOneWidget);

          // Abrir el menú desplegable "A"
          await tester.ensureVisible(dropdownTo);
          await tester.tap(dropdownTo, warnIfMissed: false);
          await tester.pumpAndSettle();

          await tester.pump(const Duration(milliseconds: 1500)); // Agregar retardo

          // Seleccionar la moneda "USD" en el menú desplegable "A"
          await tester.tap(find
              .text('EUR')
              .last);
          await tester.pumpAndSettle();

          // Encontrar el botón "Convertir" y asegurarse de que esté presente
          final button = find.byKey(const Key('convertButton'));
          expect(button, findsOneWidget);

          // Presionar el botón "Convertir"
          await tester.tap(button);
          await tester.pumpAndSettle(const Duration(milliseconds: 2500));

          // Encontrar el botón "Agregar a favoritos" y asegurarse de que esté presente
          final buttonFav = find.byIcon(Icons.favorite);
          expect(buttonFav, findsOneWidget);

          // Presionar el botón "Agregar a favoritos"
          await tester.tap(buttonFav);
          await tester.pumpAndSettle(const Duration(milliseconds: 2500));

          //Pres el boton de favoritos otra vez
          await tester.tap(buttonFav);
          await tester.pumpAndSettle(const Duration(milliseconds: 2500));

          // Comprobar que se muestra el mensaje de error
          expect(find.text('Esta moneda ya está en favoritos.'), findsOneWidget);
          await tester.pumpAndSettle(const Duration(milliseconds: 2500));

        });
  });

}



