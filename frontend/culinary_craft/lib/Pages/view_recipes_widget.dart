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
                // Poți adăuga aici acțiunile pe care dorești să le efectuezi când se apasă pe o rețetă
                print('Recipe ${recipe.name} was tapped!');
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
}