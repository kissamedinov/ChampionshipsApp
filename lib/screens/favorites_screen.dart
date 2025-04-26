import 'package:flutter/material.dart';
import '../models/match.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Match> matches;
  const FavoritesScreen({super.key, required this.matches});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Match> favoriteMatches;

  @override
  void initState() {
    super.initState();
    favoriteMatches = widget.matches.where((m) => m.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Избранные матчи")),
      body: favoriteMatches.isEmpty
          ? const Center(child: Text("Нет избранных матчей"))
          : ListView.builder(
              itemCount: favoriteMatches.length,
              itemBuilder: (context, index) {
                final match = favoriteMatches[index];
                return Dismissible(
                  key: Key(match.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    setState(() {
                      match.isFavorite = false;
                      favoriteMatches.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text('${match.team1} vs ${match.team2}'),
                    subtitle: Text('${match.date.toLocal().toString().substring(0, 16)}'),
                    trailing: const Icon(Icons.star, color: Colors.amber),
                  ),
                );
              },
            ),
    );
  }
}
