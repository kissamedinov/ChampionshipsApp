class Match {
  final int id;
  final String team1;
  final String team2;
  final DateTime date;
  final String stadium;
  bool isFavorite;
  
  Match({
    required this.id,
    required this.team1,
    required this.team2,
    required this.date,
    required this.stadium,
    this.isFavorite = false,
  });

  String get title => '$team1 vs $team2';

  String get formattedDate => '${date.toLocal()}'.substring(0, 16);  // Для отображения формата даты
}
