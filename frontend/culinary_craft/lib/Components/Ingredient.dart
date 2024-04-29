class Ingredient {
  String name;
  String imageURL;
  bool selected;

  Ingredient({
    required this.name,
    required this.imageURL,
    this.selected = false,
  });
}