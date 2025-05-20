// lib/screens/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/match.dart';
import '../providers/cart_provider.dart';
import 'package:flutter_application_1/widgets/animated_widgets.dart';
import '../widgets/match_modal.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Match> matches;
  const FavoritesScreen({super.key, required this.matches});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Match> favoriteMatches;
  String _sortOption = 'date';

  @override
  void initState() {
    super.initState();
    favoriteMatches = widget.matches.where((m) => m.isFavorite).toList();
    _sortMatches();
  }

  void _sortMatches() {
    setState(() {
      if (_sortOption == 'date') {
        favoriteMatches.sort((a, b) => a.date.compareTo(b.date));
      } else if (_sortOption == 'name') {
        favoriteMatches.sort((a, b) =>
            '${a.team1} vs ${a.team2}'.compareTo('${b.team1} vs ${b.team2}'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Matches"),
        actions: [
          DropdownButton<String>(
            value: _sortOption,
            icon: const Icon(Icons.sort, color: Colors.white),
            underline: const SizedBox(),
            dropdownColor: Colors.blue,
            onChanged: (value) {
              if (value != null) {
                _sortOption = value;
                _sortMatches();
              }
            },
            items: const [
              DropdownMenuItem(
                value: 'date',
                child: Text('By Date', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'name',
                child: Text('By Name', style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
      body: favoriteMatches.isEmpty
          ? const Center(child: Text("No favorite matches"))
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
                  child: AnimatedMatchCard(
                    match: match,
                    onTap: () => showMatchModal(context, match),
                    onDoubleTap: () {
                      setState(() {
                        match.isFavorite = false;
                        favoriteMatches.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
