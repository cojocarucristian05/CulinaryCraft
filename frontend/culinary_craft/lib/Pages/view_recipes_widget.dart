import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../Components/Ingredient.dart';
import '../Components/Recipe.dart';
import '../Components/recipe_widget.dart';
import '../Services/recipe_service.dart';
import '../Services/auth_service.dart';

class ViewRecipesWidget extends StatefulWidget {
  final List<Ingredient> selectedIngredients;
  final Uint8List? imageData;
  ViewRecipesWidget({required this.selectedIngredients, this.imageData});

  @override
  _ViewRecipesWidgetState createState() => _ViewRecipesWidgetState();
}

class _ViewRecipesWidgetState extends State<ViewRecipesWidget> {
  List<Recipe> recipes = [];
  int currentPage = 0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchRecipes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        _searchRecipes();
      }
    });
  }

  Future<void> _searchRecipes() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<int> ingredientsIds = widget.selectedIngredients.map((ingredient) => ingredient.id).toList();
      final List<Recipe> searchedRecipes = await RecipeService.searchRecipes(ingredientsIds, currentPage);
      setState(() {
        recipes.addAll(searchedRecipes);
        currentPage++;
      });
    } catch (e) {
      print('Error searching recipes: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
        iconTheme: IconThemeData(
          color: Colors.white, // Culoarea săgeții de întoarcere
        ),
        backgroundColor: Color(0xFF00b4d8),
      ),
      backgroundColor: Color(0xFF00b4d8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: recipes.length + (isLoading ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == recipes.length) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final recipe = recipes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsScreen(recipe: recipe),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: RecipeCard(recipe: recipe),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;
  RecipeDetailsScreen({required this.recipe});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    int? userId = await AuthService.getId();
    if (userId != null) {
      setState(() {
        isFavorite = widget.recipe.likes.any((like) => like.id == userId);
      });
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      bool success;
      if (isFavorite) {
        success = await RecipeService.removeRecipeFromFavourites(widget.recipe.id);
      } else {
        success = await RecipeService.addRecipeToFavourites(widget.recipe.id);
      }

      if (success) {
        setState(() {
          isFavorite = !isFavorite;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update favourite status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the server')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // Do something to make the image bigger
                  });
                },
                child: _buildRecipeImage(widget.recipe.imageURL, widget.recipe.imageData),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Name: ${widget.recipe.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Description: ${widget.recipe.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: widget.recipe.ingredients
                  .map((ingredient) => Chip(label: Text(ingredient.name)))
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : null,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildRecipeImage(String imageUrl, Uint8List imageData) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: 350,
        height: 250,
        fit: BoxFit.cover,
      );
    } else if (imageData.isNotEmpty) {
      return Image.memory(
        imageData,
        width: 350,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        width: 350,
        height: 250,
        color: Colors.grey,
        child: Icon(Icons.image, size: 50, color: Colors.white),
      );
    }
  }
}
