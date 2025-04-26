import 'package:flutter/material.dart';
import '/models/league_category.dart';  // Импортируем модель LeagueCategory
import '/pages/category_detail_page.dart'; // Импортируем страницу с деталями

class CategoryCard extends StatelessWidget {
  final LeagueCategory category;  // Передаем модель лиги

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    
    double imageSize = screenWidth * 0.3;  
    double cardHeight = screenHeight * 0.2; 

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailPage(category: category),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: screenWidth * 0.9,  
          height: cardHeight,  
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Image.network(
                category.logo,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
              
              Text(
                category.name,
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
