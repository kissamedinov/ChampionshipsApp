// lib/models/user_match.dart
import 'package:flutter/foundation.dart';

// lib/models/user_match.dart
class UserMatch {
  final int? id;
  final String homeTeam;
  final String awayTeam;
  final DateTime dateTime;
  final String stadium;

  UserMatch({
    this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.dateTime,
    required this.stadium,
  });

  UserMatch copyWith({
    int? id,
    String? homeTeam,
    String? awayTeam,
    DateTime? dateTime,
    String? stadium,
  }) {
    return UserMatch(
      id: id ?? this.id,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      dateTime: dateTime ?? this.dateTime,
      stadium: stadium ?? this.stadium,
    );
  }

  Map<String, dynamic> toMap() => {
        'id':        id,
        'home_team': homeTeam,
        'away_team': awayTeam,
        'date_time': dateTime.toIso8601String(),
        'stadium':   stadium,
      };

  factory UserMatch.fromMap(Map<String, dynamic> map) => UserMatch(
        id:        map['id'] as int?,
        homeTeam:  map['home_team'] as String,
        awayTeam:  map['away_team'] as String,
        dateTime:  DateTime.parse(map['date_time'] as String),
        stadium:   map['stadium'] as String,
      );
}
