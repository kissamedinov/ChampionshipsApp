import 'package:flutter/material.dart';
import '../../models/league_category.dart'; 

class CategoryDetailPage extends StatelessWidget {
  final LeagueCategory category;  

  CategoryDetailPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),  
        backgroundColor: Colors.blueAccent,  
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              width: double.infinity,  
              height: 200,  
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(category.logo),
                  fit: BoxFit.contain,  // Сохраняем пропорции изображения
                ),
                borderRadius: BorderRadius.circular(10), 
              ),
            ),
            SizedBox(height: 16),  
            Text(
              category.description,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
