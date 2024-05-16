import 'package:flutter/material.dart';

class IngredientWidget extends StatelessWidget {
  final int id;
  final String name;
  final String imageURL;
  final bool selected;
  final VoidCallback onTap;

  IngredientWidget({
    required this.id,
    required this.name,
    required this.imageURL,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completeImageURL = imageURL.startsWith('http') ? imageURL : 'https://$imageURL';

    return GestureDetector(
      onLongPress: () {
        _showIngredientDetails(context, completeImageURL);
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Color(0xFF90E0EF) : Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(8.0),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                completeImageURL,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 50);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
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
              padding: const EdgeInsets.only(right: 8.0),
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

  void _showIngredientDetails(BuildContext context, String completeImageURL) {
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
                child: Image.network(
                  completeImageURL,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, size: 100);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(fontSize: 18),
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
