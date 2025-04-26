import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'matches_screen.dart';

class LeaguesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select League"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Premier League'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchesScreen(league: 'Premier League'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('La Liga'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchesScreen(league: 'La Liga'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Serie A'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchesScreen(league: 'Serie A'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Bundesliga'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchesScreen(league: 'Bundesliga'),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Ligue 1'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchesScreen(league: 'Ligue 1'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
