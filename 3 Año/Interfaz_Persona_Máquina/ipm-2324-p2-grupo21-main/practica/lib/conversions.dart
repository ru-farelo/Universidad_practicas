import 'dart:async';
import 'package:flutter/material.dart';
import 'model.dart';

// CLASE QUE REPRESENTA UNA CONVERSION (TIENE EL RESULTADO DE LA CONVERSION Y LA MONEDA DE DESTINO)
class ConversionInfo {
  String to;
  double result = 0;

  ConversionInfo(this.to, this.result);
}

class Conversion with ChangeNotifier {
  int _currentAmount = 0;
  String _currentOrigin = 'EUR';
  final List<ConversionInfo> _conversions = [];
  final Model _model = Model();

  Conversion() {
    _conversions.add(ConversionInfo('USD', 0));
  }

  // PARA OBTENER LA CANTIDAD ACTUAL
  int get currentAmount => _currentAmount;

  // PARA COMPROBAR QUE EL ORIGEN QUE VAYAMOS A METER COMO NUEVO NO COINCIDA CON ALGUN DESTINO QUE TENGAMOS
  bool isValidOrigin(String newOrigin) {
    return _conversions.every((conversion) => conversion.to != newOrigin);
  }

  // PARA COMPROBAR QUE EL DESTINO QUE VAYAMOS A METER COMO NUEVO EN UNA CONVERSION SEA DISTINTO QUE EL ORIGEN ACTUAL
  bool isValidDestination(String newDestination) {
    return newDestination != _currentOrigin;
  }

  // PARA OBTENER EL ORIGEN ACTUAL
  String get currentOrigin => _currentOrigin;

  Future<void> changeCurrentAmount(int newAmount, BuildContext context) async {
    _currentAmount = newAmount;
    await _updateConversionInfo(context);
    notifyListeners();
  }

  Future<void> changeCurrentOrigin(String newOrigin, BuildContext context) async {
    _currentOrigin = newOrigin;
    await _updateConversionInfo(context);
    notifyListeners();
  }

  List<ConversionInfo> get conversions => _conversions;

  Future<void> changeDestination(String newDestination, BuildContext context) async {
    for (var i = 0; i < _conversions.length; i++) {
      _conversions[i].to = newDestination;
      await _updateConversionInfo(context, i);
    }
    notifyListeners();
  }

  Future<void> _updateConversionInfo(BuildContext context, [int index = 0]) async {
    await _model
        .getConversion(context, _currentOrigin, _conversions[index].to, _currentAmount)
        .then((value) {
      _conversions[index].result = value;
    });
  }

  // PARA OBTENER LA LISTA DE CONVERSIONES

  String getDestinationByIndex(int index) {
    return _conversions[index].to;
  }
}