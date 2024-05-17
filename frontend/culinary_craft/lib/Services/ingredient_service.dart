import 'dart:convert';

import '../Components/Ingredient.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;

class IngredientService {
  static Future<List<Ingredient>> getIngredients(int pageNumber) async {
    const pageSize = 20;
    final uri = Uri.parse("$baseURL/$ingredientsPath?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");

    try {
      final response = await http.get(uri, headers: headers);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        print(responseBody);
        if (responseBody.containsKey('content') && responseBody['content'] is List) {
          final List<dynamic> data = responseBody['content'];

          return data.asMap().entries.map((entry) {
            int index = entry.key;
            var json = entry.value;
            return Ingredient(
              id: index,
              name: json['name'],
              imageURL: json['imageUrl'],
              selected: false,
            );
          }).toList();
        } else {
          // Handle unexpected response format
          throw Exception('Unexpected response format');
        }
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