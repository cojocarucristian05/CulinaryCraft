import 'dart:typed_data';

import 'Ingredient.dart';
import 'Like.dart';

class Recipe {
  final int id;
  final String name;
  final String description;
  final String imageURL;
  final List<Ingredient> ingredients;
  final List<Like> likes;
  final Uint8List imageData;

  Recipe( {
    required this.id,
    required this.name,
    required this.description,
    required this.imageURL,
    required this.ingredients,
    required this.likes,
    required this.imageData
  });
}
