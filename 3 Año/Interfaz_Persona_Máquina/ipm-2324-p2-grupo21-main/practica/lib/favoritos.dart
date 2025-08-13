import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

class FavoritosInfo {
  int amount;
  String from;
  String to;
  double result;

  FavoritosInfo(this.amount, this.from, this.to, this.result);

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'from': from,
    'to': to,
    'result': result,
  };

  factory FavoritosInfo.fromJson(Map<String, dynamic> json) {
    return FavoritosInfo(
      json['amount'],
      json['from'],
      json['to'],
      json['result'],
    );
  }
}

class Favoritos with ChangeNotifier {
  final List<FavoritosInfo> _favoritos = [];
  final Model _model = Model();
  Favoritos() {
    _loadFavorites();
  }
  List<FavoritosInfo> get favoritos => _favoritos;

  void addFavorites(int amount, String from, String to, double result) {
    FavoritosInfo conversionInfo = FavoritosInfo(amount, from, to, result);
    _favoritos.add(conversionInfo);
    _saveFavorites();
    notifyListeners();
  }

  void deleteFavorites(FavoritosInfo conversionInfo) {
    _favoritos.remove(conversionInfo);
    _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(FavoritosInfo conversionInfo) {
    return _favoritos.contains(conversionInfo);
  }

  Future<void> changeAmountFavoritos(int newAmount, BuildContext context) async {
    for (var i = 0; i < _favoritos.length; i++) {
      _favoritos[i].amount = newAmount;
      await _updateConversionInfo(context, i);
    }
    _saveFavorites();
    notifyListeners();
  }

  Future<void> changeOriginFavoritos(String origin, BuildContext context) async {
    for (var i = 0; i < _favoritos.length; i++) {
      _favoritos[i].from = origin;
      await _updateConversionInfo(context, i);
    }
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _updateConversionInfo(BuildContext context, int index) async {
    await _model
        .getConversion(context, _favoritos[index].from, _favoritos[index].to, _favoritos[index].amount)
        .then((value) {
      _favoritos[index].result = value;
    });
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = _favoritos.map((favorito) => json.encode(favorito.toJson())).toList();
    await prefs.setStringList('favorites', favorites);
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites');
    if (favorites != null) {
      _favoritos.clear();
      _favoritos.addAll(favorites.map((favorite) => FavoritosInfo.fromJson(json.decode(favorite))));
      notifyListeners();
    }
  }

}