import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

            return Recipe(
              id: json['id'] ?? 0,
              name: json['name'] ?? 'Unknown',
              description: json['description'] ?? 'No description available',
              imageURL: json['imageUrl'] ?? '',
              ingredients: ingredients,
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

  static Future<List<Recipe>> getAllRecipesByUserPagination() async {
    const pageNumber = 0;
    const pageSize = 8;
    int? userId = await AuthService.getId();

    final uri = Uri.parse(
        "$baseURL/$recipesPath/all/user/$userId?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
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
          return Recipe(
            id: json['id'],
            name: json['name'],
            description: json['description'],
            imageURL: json['imageUrl'],
            ingredients: ingredients,
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
      final response = await http.get(uri);
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

  static Future<List<Recipe>> getFavouritesRecipesByUserPagination() async {
    const pageNumber = 0;
    const pageSize = 8;
    int? userId = await AuthService.getId();

    final uri = Uri.parse("$baseURL/$recipesPath/favourites/user-id=$userId?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
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
          return Recipe(
            id: json['id'],
            name: json['name'],
            description: json['description'],
            imageURL: json['imageUrl'],
            ingredients: ingredients,
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
}
