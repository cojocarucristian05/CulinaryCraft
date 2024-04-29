import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';


class IngredientWidget extends StatelessWidget {
  final String name;
  final String imageURL;
  final bool selected;
  final VoidCallback onTap;

  IngredientWidget({
    required this.name,
    required this.imageURL,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showIngredientDetails(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Color(0xFF90E0EF) : Color(0xFFFFFF),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0), // Adăugăm un mic spațiu între imagine și marginea din stânga
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageURL,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            name,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0), // Adăugăm un mic spațiu între buton și marginea din dreapta
              child: Container(
                alignment: Alignment.center,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: selected ? Colors.red : Color(0xFF90E0EF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  selected ? Icons.remove : Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showIngredientDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  imageURL,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(fontSize: 18), // Mărimea textului mărită
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
