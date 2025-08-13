import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'server_stub.dart' as stub;
//
class Model {
  // FUNCION PARA EL TRATAMIENTO DE LOS ERRORES
  void createErrorWindow(BuildContext context, String error) {
    Navigator.of(context)
        .pop(); // CERRAMOS EL SPINNER DE CARGA, YA QUE HAY UN ERROR
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(error),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
  }

  Future<double> getConversion(BuildContext context, String origin,
      String destination, int amount) async {
    try {
      //Usar el server stub

      var uri = Uri(
          scheme: 'https',
          host: 'fcsapi.com',
          path: "/api-v3/forex/latest",
          queryParameters: {
            'symbol': "$origin/$destination",
            'access_key': 'MY_API_KEY',
          });
      var response = await stub.get(uri);

      //Usar el server real

      // var uri = Uri.https('fcsapi.com', '/api-v3/forex/latest');
      // var response = await http.post(uri, body: {
      //   'symbol': "$origin/$destination",
      //   'access_key': 'X7kcT7BbvX4f6cK6zH4Q8D'
      // }).timeout(const Duration(seconds: 15));


      if (400 <= response.statusCode && response.statusCode <= 499) {
        throw ('Client Error. Code:${response.statusCode}');
      }
      if (500 <= response.statusCode && response.statusCode <= 599) {
        throw ('Server Error. Code:${response.statusCode}');
      }
      var dataAsDartMap = jsonDecode(response.body);

      if (dataAsDartMap["code"] == 213) {
        throw ('You reached the maximun requests per minute');
      }
      if (dataAsDartMap["code"] == 113) {
        throw ('Incorrect arguments');
      }
      String currentStr = dataAsDartMap["response"][0]["c"];
      double current = double.parse(currentStr);
      double result = current * amount;

      return result;
    } catch (e) {

      if (e is TimeoutException) {
        // ignore: use_build_context_synchronously
        createErrorWindow(context, 'Tiempo de espera alcanzado,por favor revise su conexion a internet');
      } else if (e is SocketException) {
        // ignore: use_build_context_synchronously
        createErrorWindow(context, 'Error de conexión con el servidor');
      } else {
        // ignore: use_build_context_synchronously
        createErrorWindow(context, e.toString());
      }

      rethrow;

    }
  }
}