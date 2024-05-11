
import 'package:culinary_craft_wireframe/Components/Ingredient.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart';

class IngredientService {
  Future<List<Ingredient>> getIngredients() async {
    const pageNumber = 0;
    const pageSize = 8;
    final uri = Uri.parse("$baseURL/$ingredientsPath?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Ingredient(
          name: json['name'],
          imageURL: json['imageUrl'],
          selected: false, // You can set this based on your logic if needed
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