import 'package:flutter/material.dart';
import 'Recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFCAF0F8), // Setăm culoarea cardului
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imaginea rețetei
            _buildRecipeImage(recipe.imageURL),
            SizedBox(height: 8), // Spațiu mic între imagine și text
            // Numele rețetei
            Text(
              recipe.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        imageUrl,
        width: 150,
        height: 150,
        fit: BoxFit.cover,
      );
    }
  }
}
