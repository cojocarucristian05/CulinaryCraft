import 'package:flutter/material.dart';
import '../Components/Recipe.dart';
import '../Components/recipe_widget.dart';
import '../Services/recipe_service.dart';

class ViewRecipesWidget extends StatefulWidget {
  @override
  _ViewRecipesWidgetState createState() => _ViewRecipesWidgetState();
}

class _ViewRecipesWidgetState extends State<ViewRecipesWidget> {
  List<Recipe> recipes = [];
  int pageNumber = 0;
  final int pageSize = 8;
  bool isLoading = false;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMoreRecipes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          hasMore) {
        _loadMoreRecipes();
      }
    });
  }

  Future<void> _loadMoreRecipes() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newRecipes =
      await RecipeService.getAllRecipesPagination(pageNumber);
      setState(() {
        pageNumber++;
        recipes.addAll(newRecipes);
        isLoading = false;
        hasMore = newRecipes.length == pageSize;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasMore = false;
      });
      print('Failed to load recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: recipes.length + (hasMore ? 1 : 0),
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            // Imaginea rețetei
            GestureDetector(
              onTap: () {
                setState(() {
                  // Do something to make the image bigger
                });
              },
              child: Image.network(
                widget.recipe.imageURL,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            // Numele și descrierea rețetei
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
            // Lista de ingrediente
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.recipe.ingredients.map((ingredient) {
                return Text(
                  ingredient.name,
                  style: TextStyle(fontSize: 16),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isFavorite = !isFavorite;
          });
        },
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : null,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
