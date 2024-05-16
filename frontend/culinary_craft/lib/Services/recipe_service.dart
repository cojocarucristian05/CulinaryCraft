
import 'dart:ffi';

import 'package:culinary_craft_wireframe/Components/Recipe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_service.dart';
import 'globals.dart';

class RecipeService {

  static Future<List<Recipe>> getAllRecipesPagination() async {
    const pageNumber = 0;
    const pageSize = 8;
    final uri = Uri.parse("$baseURL/$recipesPath/all?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Recipe(
          name: json['name'],
          description: json['description'],
          imageURL: json['imageUrl'],
        )).toList();
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load ingredients');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<List<Recipe>> getAllRecipesByUserPagination() async {
    const pageNumber = 0;
    const pageSize = 8;
    int? userId = await AuthService.getId();

    final uri = Uri.parse("$baseURL/$recipesPath/all/user/$userId?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Recipe(
          name: json['name'],
          description: json['description'],
          imageURL: json['imageUrl'],
        )).toList();
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load ingredients');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<bool> craftRecipe(BuildContext context, String name, String description,
                                  String imageUrl, Array ingredientsId) async {
    int? userId = await AuthService.getId();
    final uri = Uri.parse("$baseURL/$recipesPath/user/$userId");

    Map data = {
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
        // If the server did not return a 201 CREATED response,
        // throw an exception.
        throw Exception('Failed to load ingredients');
      }
    } catch (e) {
      // Handle network errors
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
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load ingredients');
      }
    } catch (e) {
      // Handle network errors
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
        return data.map((json) => Recipe(
          name: json['name'],
          description: json['description'],
          imageURL: json['imageUrl'],
        )).toList();
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load ingredients');
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }
}