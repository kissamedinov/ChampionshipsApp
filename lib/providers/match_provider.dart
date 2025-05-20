// lib/providers/match_provider.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_match.dart';

class MatchProvider with ChangeNotifier {
  static const _storageKey = 'user_matches';
  final List<UserMatch> _matches = [];

  List<UserMatch> get matches => List.unmodifiable(_matches);

  MatchProvider() {
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      _matches
        ..clear()
        ..addAll(
          decoded
            .map((m) => UserMatch.fromMap(Map<String, dynamic>.from(m))),
        );
    }
    notifyListeners();
  }

  Future<void> _saveMatches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_matches.map((m) => m.toMap()).toList()),
    );
  }

  Future<void> addMatch(UserMatch match) async {
    // генерируем уникальный id по времени
    final withId = match.copyWith(id: DateTime.now().millisecondsSinceEpoch);
    _matches.add(withId);
    await _saveMatches();
    notifyListeners();
  }

  Future<void> updateMatch(UserMatch updated) async {
    final idx = _matches.indexWhere((m) => m.id == updated.id);
    if (idx != -1) {
      _matches[idx] = updated;
      await _saveMatches();
      notifyListeners();
    }
  }

  Future<void> deleteMatch(int id) async {
    _matches.removeWhere((m) => m.id == id);
    await _saveMatches();
    notifyListeners();
  }

  /// Если нужна фильтрация в UI — вызывайте этот метод, или фильтруйте локально по matches.
  void filterMatches(String query) {
    // оставляем пустым, тк фильтрацию можно делать прямо в UI
    notifyListeners();
  }
}
