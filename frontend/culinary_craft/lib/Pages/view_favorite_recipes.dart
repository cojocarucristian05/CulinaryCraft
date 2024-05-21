import 'package:flutter/material.dart';
import '../Components/Ingredient.dart';
import '../Components/Recipe.dart';
import '../Components/recipe_widget.dart';
import '../Services/auth_service.dart';
import '../Services/recipe_service.dart';

class ViewFavoriteRecipesWidget extends StatefulWidget {

  ViewFavoriteRecipesWidget();

  @override
  _ViewFavoriteRecipesWidgetState createState() => _ViewFavoriteRecipesWidgetState();
}

class _ViewFavoriteRecipesWidgetState extends State<ViewFavoriteRecipesWidget> {
  List<Recipe> recipes = []; // Lista de rețete căutate
  int currentPage = 0; // Pagina curentă pentru paginare
  bool isLoading = false; // Stare pentru a urmări dacă se încarcă date

  final ScrollController _scrollController = ScrollController(); // Controller pentru Scroll

  @override
  void initState() {
    super.initState();
    _searchRecipes(); // Înainte de a afișa widget-ul, se caută rețetele pe baza ingredientelor selectate

    // Adaugă un listener pentru scroll pentru a încărca mai multe date când utilizatorul ajunge la capătul listei
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        _searchRecipes();
      }
    });
  }

  Future<void> _searchRecipes() async {
    setState(() {
      isLoading = true; // Setează starea de încărcare
    });

    try {
      // Apelează funcția pentru a căuta rețetele pe baza ingredientelor selectate și a paginii curente
      final List<Recipe> searchedRecipes = await RecipeService.getFavouritesRecipesByUserPagination(currentPage);
      setState(() {
        recipes.addAll(searchedRecipes); // Adaugă noile rețete la lista existentă
        currentPage++; // Incrementează pagina curentă
      });
    } catch (e) {
      print('Error searching recipes: $e');
      // În cazul unei erori, poți trata situația aici (cum ar fi afișarea unui mesaj de eroare)
    } finally {
      setState(() {
        isLoading = false; // Resetează starea de încărcare
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
        title: Text('Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: recipes.length + (isLoading ? 1 : 0), // Adaugă un item pentru indicatorul de încărcare
          itemBuilder: (BuildContext context, int index) {
            if (index == recipes.length) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final recipe = recipes[index];
            return GestureDetector(
              onTap: () {
                // Deschide pagina de detalii a rețetei când se apasă pe un card de rețetă
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
            GestureDetector(
              onTap: () {
                setState(() {
                  // Do something to make the image bigger
                });
              },
              child: _buildRecipeImage(widget.recipe.imageURL),
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

  Widget _buildRecipeImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }
}