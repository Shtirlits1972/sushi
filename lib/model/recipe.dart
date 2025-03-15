import 'dart:typed_data';
import 'package:sushi_sql/model/recipe_row.dart';

class Recipe {
  int id = 0;
  String name = '';
  Uint8List? image;
  List<RecipeRow> RecipeRows = [];

  Recipe(this.id, this.name, this.image, this.RecipeRows);
  Recipe.empty() {
    id = 0;
    name = '';
    image = null;
    RecipeRows = [];
  }

  // Метод для создания экземпляра из Map
  factory Recipe.fromMap(Map<dynamic, dynamic> map) {
    return Recipe(
      map['id'] ?? 0,
      map['name'] ?? '',
      map['image'],
      map['RecipeRows'] ?? [],
    );
  }

  // Метод для преобразования экземпляра в Map
  Map<String, dynamic> toMap() {
    return {'name': name, 'image': image};
  }

  @override
  String toString() {
    return 'Recipe {id = $id, name = $name, image (isNull) = ${image == null} RecipeRows = $RecipeRows }';
  }
}
