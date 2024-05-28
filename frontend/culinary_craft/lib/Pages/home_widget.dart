import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Components/Ingredient.dart';
import '../Components/ingredient_widget.dart';
import '../Components/appbar_widget.dart';
import '../Services/ingredient_service.dart';
import '../Services/recipe_service.dart'; // Importăm serviciul pentru rețete
import 'view_recipes_widget.dart'; // Importăm widget-ul de vizualizare a rețetelor

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Ingredient> ingredients = [];
  List<Ingredient> selectedIngredients = [];
  int currentPage = 0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  late Future<void> _initialLoad;

  @override
  void initState() {
    super.initState();
    _initialLoad = _fetchIngredients();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        _fetchIngredients();
      }
    });
  }

  Future<void> _fetchIngredients() async {
    setState(() {
      isLoading = true;
    });

    try {
      final newIngredients = await IngredientService.getIngredients(currentPage);
      setState(() {
        ingredients.addAll(newIngredients);
        currentPage++;
      });
    } catch (e) {
      print('Failed to load ingredients: $e');
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
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomAppbarWidget(
        homeRoute: '/home',
        profileRoute: '/profile',
      ),
      body: FutureBuilder(
        future: _initialLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load ingredients'));
          } else {
            return _buildIngredientList();
          }
        },
      ),
    );
  }

  Widget _buildIngredientList() {
    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Craft recipes',
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Text(
              'Select your ingredients:',
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: ingredients.length + (isLoading ? 1 : 0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == ingredients.length) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final ingredient = ingredients[index];
                  return Column(
                    children: [
                      IngredientWidget(
                        id: ingredient.id,
                        name: ingredient.name,
                        imageURL: ingredient.imageURL,
                        selected: ingredient.selected,
                        onTap: () {
                          setState(() {
                            toggleIngredientSelection(ingredient);
                          });
                        },
                      ),
                      SizedBox(height: 5),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIngredients.isNotEmpty
                    ? () async {
                  // Navighează către pagina de vizualizare a rețetelor și trimite lista de rețete
                  Navigator.of(context).pushNamed('/create_recipes', arguments: selectedIngredients);
                }
                    : null, // Dezactivează butonul dacă nu sunt ingrediente selectate
                child: Text(
                  'Create Recipe',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0077B6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIngredients.isNotEmpty
                    ? () async {
                  final recipes = await RecipeService.searchRecipes(
                    selectedIngredients.map((ing) => ing.id).toList(),
                    0,
                  );
                  if (recipes.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No recipes found.'),
                      ),
                    );
                  } else {
                    Navigator.of(context).pushNamed('/view_recipes',
                        arguments: selectedIngredients);
                  }
                }
                    : null,
                child: Text(
                  'Search Recipes',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0077B6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleIngredientSelection(Ingredient ingredient) {
    setState(() {
      if (selectedIngredients.contains(ingredient)) {
        selectedIngredients.remove(ingredient);
        ingredient.selected = false;
      } else {
        selectedIngredients.add(ingredient);
        ingredient.selected = true;
      }
      for (Ingredient ing in selectedIngredients) {
        print(ing.name);
      }
    });
  }
}
