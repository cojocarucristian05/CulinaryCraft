import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../Components/Ingredient.dart';
import '../Components/Recipe.dart';
import '../Components/recipe_widget.dart';
import '../Services/recipe_service.dart';
import '../Services/auth_service.dart';

class ViewMyRecipesWidget extends StatefulWidget {
  ViewMyRecipesWidget();

  @override
  _ViewMyRecipesWidgetState createState() => _ViewMyRecipesWidgetState();
}

class _ViewMyRecipesWidgetState extends State<ViewMyRecipesWidget> {
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
      final List<Recipe> searchedRecipes = await RecipeService.getAllRecipesByUserPagination(currentPage);
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

  Future<void> _onRecipeDeleted(Recipe deletedRecipe) async {
    setState(() {
      recipes.removeWhere((recipe) => recipe.id == deletedRecipe.id);
    });
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
        iconTheme: IconThemeData(
          color: Colors.white, // Culoarea săgeții de întoarcere
        ),
        title: Text('My Recipes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: Color(0xFF00b4d8),
      ),
      backgroundColor: Color(0xFF00b4d8),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: recipes.isEmpty
            ? Center(
          child: Text(
            'No recipes found.',
            style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold,color:Colors.white),
          ),
        )
            : ListView.builder(
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
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsScreen(recipe: recipe),
                  ),
                );
                if (result == true) {
                  await _onRecipeDeleted(recipe);
                }
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
  }

  Future<void> _deleteRecipe() async {
    try {
      bool success = await RecipeService.deleteRecipe(widget.recipe.id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe deleted successfully')),
        );
        Navigator.of(context).pop(true); // Indicate that the recipe was deleted
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete recipe')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the server')),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this recipe?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteRecipe();
              },
            ),
          ],
        );
      },
    );
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
        onPressed: _showDeleteConfirmationDialog,
        child: Icon(
          Icons.delete,
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
