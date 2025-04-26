import 'package:flutter/material.dart';
import '../models/match.dart';
import 'match_modal.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const MatchCard({
    super.key,
    required this.match,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${match.team1} vs ${match.team2}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('📍 ${match.stadium}'),
              Text('🗓 ${match.date.toLocal().toString().substring(0, 16)}'),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  match.isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
              ),
              // Добавлена кнопка "Добавить в корзину"
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Логика добавления в корзину
                    context.read<CartProvider>().add(match);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added ${match.team1} vs ${match.team2} to cart')),
                    );
                  },
                  child: const Text('Add to Cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // backgroundColor вместо primary
                    foregroundColor: Colors.white, // foregroundColor вместо onPrimary
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
