import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/match_data.dart';
import 'match_card.dart';
import 'match_modal.dart';

class UpcomingMatchesWidget extends StatefulWidget {
  const UpcomingMatchesWidget({super.key});

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
        ...mockMatches.map((match) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: MatchCard(
                match: match,
                onTap: () => showMatchModal(context, match),
                onDoubleTap: () {
                  setState(() {
                    match.isFavorite = !match.isFavorite;
                  });
                },
              ),
            )),
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