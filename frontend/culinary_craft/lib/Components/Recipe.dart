import 'Ingredient.dart';

class Recipe {
  final int id;
  final String name;
  final String description;
  final String imageURL;
  final List<Ingredient> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.imageURL,
    required this.ingredients,
  });
}
