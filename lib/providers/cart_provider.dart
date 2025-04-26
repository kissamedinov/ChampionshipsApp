import 'package:flutter/material.dart';
import '../models/match.dart';

class CartProvider with ChangeNotifier {
  final List<Match> _cart = [];

  List<Match> get cart => _cart;

  void add(Match match) {
    _cart.add(match);
    notifyListeners();
  }

  void remove(Match match) {
    _cart.remove(match);
    notifyListeners();
  }
}
