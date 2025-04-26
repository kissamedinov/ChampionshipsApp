import 'package:flutter/material.dart';
import '/models/league_category.dart';  // Модель для лиги
import '/widgets/categorycard.dart'; // Импортируем карточки категорий
import '/categories_list.dart'; // Импортируем список лиг

class LeagueSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Football Leagues"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Два элемента в ряду
            crossAxisSpacing: 10, // Уменьшаем горизонтальные отступы
            mainAxisSpacing: 10, // Уменьшаем вертикальные отступы
            childAspectRatio: 0.8, // Уменьшаем высоту карточек
          ),
          itemCount: topLeagues.length,
          itemBuilder: (context, index) {
            return CategoryCard(category: topLeagues[index]);  
          },
        ),
      ),
    );
  }
}
