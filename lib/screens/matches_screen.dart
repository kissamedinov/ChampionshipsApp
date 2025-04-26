// screens/matches_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/match.dart';
import '../providers/cart_provider.dart';
import '../widgets/match_card.dart';

class MatchesScreen extends StatelessWidget {
  final String league;
  MatchesScreen({required this.league});

  @override
  Widget build(BuildContext context) {
    List<Match> matches = getMatchesForLeague(league);  // Получаем матчи для выбранной лиги

    return Scaffold(
      appBar: AppBar(
        title: Text('$league Matches'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Top Teams: Bayern Munich, Borussia Dortmund, Hamburg\nLegends: Gerd Muller, Lewandowski, Lahm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Кнопка для покупки билетов
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Логика для добавления матчей в корзину
                showTicketPurchaseDialog(context);
              },
              child: Text("Buy Tickets for Top Matches"),
            ),
          ),
          // Отображение списка матчей
          ...matches.map((match) => MatchCard(
            match: match,
            onTap: () {
              // Действие при нажатии на матч
            },
            onDoubleTap: () {
              // Действие при двойном нажатии на матч
            },
          )).toList(),
        ],
      ),
    );
  }

  List<Match> getMatchesForLeague(String league) {
    // Моковые данные для матчей лиг
    if (league == 'Premier League') {
      return [
        Match(id: 1, team1: 'Manchester United', team2: 'Liverpool', date: DateTime(2025, 5, 15), stadium: 'Old Trafford'),
        Match(id: 2, team1: 'Chelsea', team2: 'Arsenal', date: DateTime(2025, 5, 16), stadium: 'Stamford Bridge'),
      ];
    } else if (league == 'La Liga') {
      return [
        Match(id: 3, team1: 'Barcelona', team2: 'Real Madrid', date: DateTime(2025, 5, 17), stadium: 'Camp Nou'),
        Match(id: 4, team1: 'Atletico Madrid', team2: 'Sevilla', date: DateTime(2025, 5, 18), stadium: 'Wanda Metropolitano'),
      ];
    } else if (league == 'Serie A') {
      return [
        Match(id: 5, team1: 'Juventus', team2: 'AC Milan', date: DateTime(2025, 5, 20), stadium: 'Allianz Stadium'),
        Match(id: 6, team1: 'AS Roma', team2: 'Inter Milan', date: DateTime(2025, 5, 21), stadium: 'Stadio Olimpico'),
      ];
    } else if (league == 'Bundesliga') {
      return [
        Match(id: 7, team1: 'Bayern Munich', team2: 'Borussia Dortmund', date: DateTime(2025, 5, 22), stadium: 'Allianz Arena'),
        Match(id: 8, team1: 'RB Leipzig', team2: 'Bayer Leverkusen', date: DateTime(2025, 5, 23), stadium: 'Red Bull Arena'),
      ];
    } else if (league == 'Ligue 1') {
      return [
        Match(id: 9, team1: 'Paris Saint-Germain', team2: 'Olympique Lyonnais', date: DateTime(2025, 5, 24), stadium: 'Parc des Princes'),
        Match(id: 10, team1: 'Marseille', team2: 'Monaco', date: DateTime(2025, 5, 25), stadium: 'Stade Vélodrome'),
      ];
    }
    return [];
  }

  void showTicketPurchaseDialog(BuildContext context) {
    // Показываем диалог для покупки билетов
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Buy Tickets"),
          content: Text("Select the match to purchase tickets for."),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Add Tickets'),
              onPressed: () {
                context.read<CartProvider>().add(getMatchesForLeague(league).first);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tickets added to your cart')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
