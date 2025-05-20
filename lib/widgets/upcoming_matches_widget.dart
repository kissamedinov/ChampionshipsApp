// lib/widgets/upcoming_matches_widget.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/match_data.dart';
import 'match_modal.dart';
import 'package:flutter_application_1/widgets/animated_widgets.dart';

class UpcomingMatchesWidget extends StatefulWidget {
  const UpcomingMatchesWidget({Key? key}) : super(key: key);

  @override
  State<UpcomingMatchesWidget> createState() => _UpcomingMatchesWidgetState();
}

class _UpcomingMatchesWidgetState extends State<UpcomingMatchesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Text(
            "Upcoming Matches",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ...mockMatches.map((match) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: AnimatedMatchCard(
              match: match,
              onTap: () => showMatchModal(context, match),
              onDoubleTap: () {
                setState(() {
                  match.isFavorite = !match.isFavorite;
                });
              },
            ),
          );
        }).toList(),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton.icon(
            onPressed: () => context.push('/favorites'),
            icon: const Icon(Icons.star),
            label: const Text("Go to Favorites"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
