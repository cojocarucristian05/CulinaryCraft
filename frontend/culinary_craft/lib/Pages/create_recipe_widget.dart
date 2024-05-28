import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Components/Ingredient.dart';
import '../Services/recipe_service.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle; // pentru a încărca asset-ul implicit
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
class CreateRecipeWidget extends StatefulWidget {
  final List<Ingredient> ingredients;

  const CreateRecipeWidget({Key? key, required this.ingredients}) : super(key: key);

  @override
  _CreateRecipeWidgetState createState() => _CreateRecipeWidgetState();
}

class _CreateRecipeWidgetState extends State<CreateRecipeWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  final String defaultImage = 'assets/images/food.jpg';

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<File> _getDefaultImageFile() async {
    final byteData = await rootBundle.load(defaultImage);
    final file = File('${(await getTemporaryDirectory()).path}/default_image.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  Future<void> _createRecipe() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      final List<int> ingredientsId = widget.ingredients.map((ingredient) => ingredient.id).toList();
      try {
        File imageFile;
        if (_image != null) {
          imageFile = _image!;
        } else {
          imageFile = await _getDefaultImageFile();
        }
        bool success = await RecipeService.craftRecipe(context, name, description, imageFile.path, ingredientsId, imageFile);
        if (success) {
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create recipe')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Toate câmpurile sunt necesare')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Recipe Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Text('Ingredients:'),
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: widget.ingredients
                  .map((ingredient) => Chip(label: Text(ingredient.name)))
                  .toList(),
            ),
            SizedBox(height: 10),
            _image == null
                ? Image.asset(defaultImage)
                : Image.file(_image!),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createRecipe,
                child: Text('Create Recipe'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
