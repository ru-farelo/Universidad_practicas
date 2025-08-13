import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fcs_stub/main.dart';

import 'package:fcs_stub/favoritos.dart';
import 'package:fcs_stub/conversions.dart';
import 'package:provider/provider.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


  testWidgets(
      'Tiempo de espera alcazado , conexión muy lenta o error de conexion',
  (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Conversion()),
          ChangeNotifierProvider(create: (_) => Favoritos()),
        ],
        child: const ResponsiveApp(),
      ),
    );


    // Encontrar el TextFormField y asegurarse de que esté presente/
    final textFormField = find.byType(TextFormField);
    expect(textFormField, findsOneWidget);

    // Ingresar el monto '1' en el TextFormField
    await tester.enterText(textFormField, '1');

    // Encontrar el botón "Convertir" y asegurarse de que esté presente
    final button = find.byKey(const Key('convertButton'));
    expect(button, findsOneWidget);

    // Presionar el botón "Convertir"
    await tester.tap(button);
    await tester.pumpAndSettle(const Duration(seconds: 4));

    expect(find.text('Error de conexión con el servidor'), findsOneWidget);
  });



}



