
class Ingredient {
  int id;
  String name;
  String imageURL;
  bool selected;

  Ingredient({
    required this.id,
    required this.name,
    required this.imageURL,
    this.selected = false,
  });
}