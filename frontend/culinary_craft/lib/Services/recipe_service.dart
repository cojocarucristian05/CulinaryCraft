import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Components/Like.dart';
import '../Components/Recipe.dart';
import '../Components/Ingredient.dart';
import 'auth_service.dart';
import 'globals.dart';
import 'dart:io';
import 'dart:io';
import 'package:http_parser/http_parser.dart';



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
            Uint8List imageData = Uint8List(0);
            if (json.containsKey('imageData') && json['imageData'] is String) {
              try {
                imageData = base64Decode(json['imageData']);
                print('Decoded image data successfully.');
              } catch (e) {
                print('Error decoding image data: $e');
              }
            } else {
              print('No valid image data found.');
            }

            return Recipe(
                id: json['id'],
                name: json['name'],
                description: json['description'],
                imageURL: json['imageUrl'] ?? "",
                ingredients: ingredients,
                likes: likes,
                imageData: imageData
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
          Uint8List imageData = Uint8List(0);
          if (json.containsKey('imageData') && json['imageData'] is String) {
            try {
              imageData = base64Decode(json['imageData']);
              print('Decoded image data successfully.');
            } catch (e) {
              print('Error decoding image data: $e');
            }
          } else {
            print('No valid image data found.');
          }

          return Recipe(
              id: json['id'],
              name: json['name'],
              description: json['description'],
              imageURL: json['imageUrl'] ?? "",
              ingredients: ingredients,
              likes: likes,
              imageData: imageData
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
      String imageUrl, List<int> ingredientsId, File? image) async {
    int? userId = await AuthService.getId();
    final uri = Uri.parse("$baseURL/$recipesPath/user/$userId");

    var request = http.MultipartRequest('POST', uri)
      ..fields['name'] = name
      ..fields['description'] = description
      ..fields['imageUrl'] = imageUrl
      ..fields['ingredientsID'] = jsonEncode(ingredientsId); // trimite lista de ID-uri ca JSON

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create recipe: ${response.body}');
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
    final uri = Uri.parse("$baseURL/$recipesPath/favourites/user-id=$userId?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");

    try {
      final response = await http.get(uri);
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
          Uint8List imageData = Uint8List(0);
          if (json.containsKey('imageData') && json['imageData'] is String) {
            try {
              imageData = base64Decode(json['imageData']);
              print('Decoded image data successfully.');
            } catch (e) {
              print('Error decoding image data: $e');
            }
          } else {
            print('No valid image data found.');
          }

          return Recipe(
              id: json['id'],
              name: json['name'],
              description: json['description'],
              imageURL: json['imageUrl'] ?? "",
              ingredients: ingredients,
              likes: likes,
              imageData: imageData
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

            // Extracting likes data
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
            Uint8List imageData = Uint8List(0);
            if (json.containsKey('imageData') && json['imageData'] is String) {
              try {
                imageData = base64Decode(json['imageData']);
                print('Decoded image data successfully.');
              } catch (e) {
                print('Error decoding image data: $e');
              }
            } else {
              print('No valid image data found.');
            }

            return Recipe(
                id: json['id'],
                name: json['name'],
                description: json['description'],
                imageURL: json['imageUrl'] ?? "",
                ingredients: ingredients,
                likes: likes,
                imageData: imageData
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
