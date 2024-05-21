import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Components/Like.dart';
import '../Components/Recipe.dart';
import '../Components/Ingredient.dart';
import 'auth_service.dart';
import 'globals.dart';

class RecipeService {
  static Future<List<Recipe>> getAllRecipesPagination(int pageNumber) async {
    const pageSize = 8;
    final uri = Uri.parse(
        "$baseURL/$recipesPath/all?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody.containsKey('content') &&
            responseBody['content'] is List) {
          final List<dynamic> data = responseBody['content'];

          return data.map((json) {
            // Extracting ingredients data
            List<Ingredient> ingredients = [];
            if (json.containsKey('ingredients') &&
                json['ingredients'] is List) {
              List<dynamic> ingredientsData = json['ingredients'];
              ingredients = ingredientsData.map((ingredientJson) {
                return Ingredient(
                  id: ingredientJson['id'] ?? 0,
                  name: ingredientJson['name'] ?? 'Unknown',
                  imageURL: ingredientJson['imageURL'] ?? '',
                  selected: ingredientJson['selected'] ?? false,
                );
              }).toList();
            }
            List<Like> likes = [];
            if (json.containsKey('likes') && json['likes'] is List) {
              List<dynamic> likesData = json['likes'];
              likes = likesData.map((likeJson) {
                return Like(
                  id: likeJson['id'] ?? 0,
                  username: likeJson['username'] ?? 'Unknown',
                );
              }).toList();
            }
            return Recipe(
              id: json['id'],
              name: json['name'],
              description: json['description'],
              imageURL: json['imageUrl'],
              ingredients: ingredients,
              likes: likes,
            );
          }).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<List<Recipe>> getAllRecipesByUserPagination(int pageNumber) async {
    const pageSize = 8;
    int? userId = await AuthService.getId();

    final uri = Uri.parse(
        "$baseURL/$recipesPath/all/user/$userId?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['content'];
        return data.map((json) {
          List<Ingredient> ingredients = [];
          if (json.containsKey('ingredients') &&
              json['ingredients'] is List) {
            List<dynamic> ingredientsData = json['ingredients'];
            ingredients = ingredientsData.map((ingredientJson) {
              return Ingredient(
                id: ingredientJson['id'] ?? 0,
                name: ingredientJson['name'] ?? 'Unknown',
                imageURL: ingredientJson['imageURL'] ?? '',
                selected: ingredientJson['selected'] ?? false,
              );
            }).toList();
          }
          List<Like> likes = [];
          if (json.containsKey('likes') && json['likes'] is List) {
            List<dynamic> likesData = json['likes'];
            likes = likesData.map((likeJson) {
              return Like(
                id: likeJson['id'] ?? 0,
                username: likeJson['username'] ?? 'Unknown',
              );
            }).toList();
          }
          return Recipe(
            id: json['id'],
            name: json['name'],
            description: json['description'],
            imageURL: json['imageUrl'],
            ingredients: ingredients,
            likes: likes,
          );
        }).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<bool> craftRecipe(BuildContext context, String name, String description,
      String imageUrl, List<int> ingredientsId) async {
    int? userId = await AuthService.getId();
    final uri = Uri.parse("$baseURL/$recipesPath/user/$userId");

    Map<String, dynamic> data = {
      "name": name,
      "description": description,
      "imageUrl": imageUrl,
      "ingredientsID": ingredientsId
    };

    var body = jsonEncode(data);

    try {
      http.Response response = await http.post(
          uri,
          headers: headers,
          body: body
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create recipe');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<bool> addRecipeToFavourites(int recipeId) async {
    int? userId = await AuthService.getId();
    final uri = Uri.parse("$baseURL/$recipesPath/user-id=$userId/add-to-favourite/recipe-id=$recipeId");
    try {
      final response = await http.put(uri);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add recipe to favourites');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<bool> removeRecipeFromFavourites(int recipeId) async {
    int? userId = await AuthService.getId();
    final uri = Uri.parse("$baseURL/$recipesPath/user-id=$userId/remove-from-favourite/recipe-id=$recipeId");
    try {
      final response = await http.put(uri);
      if (response.statusCode == 204) { // No Content
        return true;
      } else {
        throw Exception('Failed to remove recipe from favourites');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<List<Recipe>> getFavouritesRecipesByUserPagination(int pageNumber) async {
    const pageSize = 8;
    int? userId = await AuthService.getId();
    print(userId);
    final uri = Uri.parse("$baseURL/$recipesPath/favourites/user-id=$userId?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");

    try {
      final response = await http.get(uri);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> data = json.decode(response.body)['content'];
        return data.map((json) {
          List<Ingredient> ingredients = [];
          if (json.containsKey('ingredients') &&
              json['ingredients'] is List) {
            List<dynamic> ingredientsData = json['ingredients'];
            ingredients = ingredientsData.map((ingredientJson) {
              return Ingredient(
                id: ingredientJson['id'] ?? 0,
                name: ingredientJson['name'] ?? 'Unknown',
                imageURL: ingredientJson['imageURL'] ?? '',
                selected: ingredientJson['selected'] ?? false,
              );
            }).toList();
          }
          List<Like> likes = [];
          if (json.containsKey('likes') && json['likes'] is List) {
            List<dynamic> likesData = json['likes'];
            likes = likesData.map((likeJson) {
              return Like(
                id: likeJson['id'] ?? 0,
                username: likeJson['username'] ?? 'Unknown',
              );
            }).toList();
          }
          return Recipe(
            id: json['id'],
            name: json['name'],
            description: json['description'],
            imageURL: json['imageUrl'],
            ingredients: ingredients,
            likes: likes,
          );
        }).toList();
      } else {
        throw Exception('Failed to load favourites recipes');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<List<Recipe>> searchRecipes(List<int> ingredientsIds, int pageNumber) async {
    const pageSize = 8;
    final uri = Uri.parse("$baseURL/$recipesPath/search?pageNumber=$pageNumber&pageSize=$pageSize");
    print(ingredientsIds);
    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode({"ingredientsID": ingredientsIds}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody.containsKey('content') && responseBody['content'] is List) {
          final List<dynamic> data = responseBody['content'];

          return data.map((json) {
            // Extracting ingredients data
            List<Ingredient> ingredients = [];
            if (json.containsKey('ingredients') && json['ingredients'] is List) {
              List<dynamic> ingredientsData = json['ingredients'];
              ingredients = ingredientsData.map((ingredientJson) {
                return Ingredient(
                  id: ingredientJson['id'] ?? 0,
                  name: ingredientJson['name'] ?? 'Unknown',
                  imageURL: ingredientJson['imageURL'] ?? '',
                  selected: ingredientJson['selected'] ?? false,
                );
              }).toList();
            }

            List<Like> likes = [];
            if (json.containsKey('likes') && json['likes'] is List) {
              List<dynamic> likesData = json['likes'];
              likes = likesData.map((likeJson) {
                return Like(
                  id: likeJson['id'] ?? 0,
                  username: likeJson['username'] ?? 'Unknown',
                );
              }).toList();
            }
            return Recipe(
              id: json['id'],
              name: json['name'],
              description: json['description'],
              imageURL: json['imageUrl'],
              ingredients: ingredients,
              likes: likes,
            );
          }).toList();
        } else {
          // Handle unexpected response format
          throw Exception('Unexpected response format');
        }
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<bool> deleteRecipe(int recipeId) async {
    int? userId = await AuthService.getId();
    final uri = Uri.parse("$baseURL/$recipesPath/user-id=$userId/delete/recipe-id=$recipeId");

    try {
      final response = await http.delete(uri, headers: headers);
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete recipe: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }
}
