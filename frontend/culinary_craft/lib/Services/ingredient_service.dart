import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../Components/Ingredient.dart';
import 'globals.dart';

class IngredientService {
  static Future<List<Ingredient>> getIngredients(int pageNumber) async {
    const pageSize = 20;
    final uri = Uri.parse("$baseURL/$ingredientsPath?$PAGE_NUMBER_REQUEST_PARAMETER=$pageNumber&$PAGE_SIZE_REQUEST_PARAMETER=$pageSize");

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody.containsKey('content') && responseBody['content'] is List) {
          final List<dynamic> data = responseBody['content'];

          return data.asMap().entries.map((entry) {
            int index = entry.key;
            var json = entry.value;
            return Ingredient(
              id: json['id'],
              name: json['name'],
              imageURL: json['imageUrl'],
              selected: false,
            );
          }).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load ingredients');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  // Metodă pentru trimiterea imaginii și primirea ingredientului identificat
  static Future<Ingredient?> sendIngredientImage(File imageFile) async {
    final uri = Uri.parse("$baseURL/images/food-recognition");

    final mimeTypeData = lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD8])?.split('/');

    if (mimeTypeData == null || mimeTypeData.length != 2) {
      throw Exception('Could not determine the file type');
    }

    try {
      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ));

      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseBody = await http.Response.fromStream(response);
        final Map<String, dynamic> responseData = json.decode(responseBody.body);
        print(responseData);
        // Verificăm dacă răspunsul conține un ingredient
        if (responseData.isNotEmpty) {
          final ingredientJson = responseData;
          return Ingredient(
            id: ingredientJson['id'],
            name: ingredientJson['name'],
            imageURL: ingredientJson['imageUrl'],
            selected: false,
          );
        } else {
          throw Exception('Ingredient not found in response');
        }
      } else {
        throw Exception('Failed to upload ingredient image');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image');
    }
  }
}
