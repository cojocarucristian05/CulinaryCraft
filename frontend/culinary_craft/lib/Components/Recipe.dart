import 'Ingredient.dart';
import 'Like.dart';

class Recipe {
  final int id;
  final String name;
  final String description;
  final String imageURL;
  final List<Ingredient> ingredients;
  final List<Like> likes;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.imageURL,
    required this.ingredients,
    required this.likes
  });
}
