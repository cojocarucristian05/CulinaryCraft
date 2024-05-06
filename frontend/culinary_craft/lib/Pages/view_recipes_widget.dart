import 'package:flutter/material.dart';
import '../Components/Recipe.dart';
import '../Components/recipe_widget.dart';

class ViewRecipesWidget extends StatelessWidget {
  // Lista de rețete
  final List<Recipe> recipes;

  // Constructorul
  ViewRecipesWidget({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Spațiu între margini
        child: ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (BuildContext context, int index) {
            final recipe = recipes[index];

            // Returnăm un GestureDetector pentru a face RecipeCard apăsabil
            return GestureDetector(
              onTap: () {
                _showRecipeDetails(context, recipe); // Afisam detaliile rețetei
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Spațiu între rețete
                child: RecipeCard(recipe: recipe),
              ),
            );
          },
        ),
      ),
    );
  }

  // Metodă pentru afișarea detaliilor rețetei într-un dialog
  void _showRecipeDetails(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(recipe.name),
          content: SingleChildScrollView( // Folosim SingleChildScrollView pentru a permite derularea conținutului
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  recipe.imageURL,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8),
                Text(
                  recipe.description,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                // Adaugă aici logica pentru adăugarea rețetei la favorite
                Navigator.of(context).pop(); // Închide dialogul
              },
            ),
          ],
        );
      },
    );
  }
}
