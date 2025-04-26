import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Импортируем для форматирования даты
import '../providers/cart_provider.dart';
import '../models/match.dart';
import '../data/match_data.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tickets'),
      ),
      body: cart.isEmpty
          ? Center(child: Text("No tickets in your cart"))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final match = cart[index];
                final formattedDate = DateFormat('yyyy-MM-dd – HH:mm').format(match.date); // Форматируем дату
                return Dismissible(
                  key: Key(match.id.toString()),
                  onDismissed: (_) {
                    cartProvider.remove(match);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Removed ${match.title} from cart')),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(match.title),
                      subtitle: Text(formattedDate),
                      trailing: Icon(Icons.remove_shopping_cart),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
