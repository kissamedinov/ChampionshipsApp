// lib/widgets/match_modal.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/match.dart';
import '../providers/cart_provider.dart';
import '../widgets/match_quantity_selector.dart';
import 'package:flutter_application_1/widgets/animated_widgets.dart';

void showMatchModal(BuildContext context, Match match) {
  int quantity = 1;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${match.team1} vs ${match.team2}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(match.date.toLocal().toString().substring(0, 16)),
              const SizedBox(height: 20),
              MatchQuantitySelector(
                quantity: quantity,
                onIncrement: () => setState(() => quantity++),
                onDecrement: () => setState(() => quantity--),
              ),
              const SizedBox(height: 20),
              AnimatedBuyButton(
                onPressed: () {
                  // Добавляем в корзину
                  context.read<CartProvider>().add(match);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Added $quantity tickets for ${match.team1} vs ${match.team2}',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
