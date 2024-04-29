import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Components/Ingredient.dart';
import '../Components/ingredient_widget.dart';
import '../Components/appbar_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late List<Ingredient> ingredients;
  List<Ingredient> selectedIngredients = [];

  @override
  void initState() {
    super.initState();
    // Inițializăm lista cu ingrediente cu datele de test
    ingredients = List.generate(10, (index) {
      return Ingredient(
        name: 'Egg',
        imageURL: 'assets/images/egg.png',
        selected: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: CustomAppbarWidget(
        homeRoute: '/home',
        profileRoute: '/profile',
      ),
      body: SafeArea(
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
                  itemCount: (ingredients.length / 2).ceil(),
                  itemBuilder: (BuildContext context, int index) {
                    final int firstIndex = index * 2;
                    final int secondIndex =
                    firstIndex + 1 < ingredients.length ? firstIndex + 1 : -1;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: secondIndex != -1
                                  ? IngredientWidget(
                                name: ingredients[firstIndex].name,
                                imageURL: ingredients[firstIndex].imageURL,
                                selected: ingredients[firstIndex].selected,
                                onTap: () {
                                  setState(() {
                                    toggleIngredientSelection(ingredients[firstIndex]);
                                  });
                                },
                              )
                                  : SizedBox(),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: secondIndex != -1
                                  ? IngredientWidget(
                                name: ingredients[secondIndex].name,
                                imageURL: ingredients[secondIndex].imageURL,
                                selected: ingredients[secondIndex].selected,
                                onTap: () {
                                  setState(() {
                                    toggleIngredientSelection(ingredients[secondIndex]);
                                  });
                                },
                              )
                                  : SizedBox(),
                            ),
                          ],
                        ),
                        SizedBox(height: 5), // Spatiu intre randuri
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Afiseaza ingredientele selectate
                    print(selectedIngredients);
                    Navigator.of(context).pushNamed('/view_recipes');
                  },
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
    for(Ingredient ing in selectedIngredients){
      print(ing.name);
    }
    });
  }
}