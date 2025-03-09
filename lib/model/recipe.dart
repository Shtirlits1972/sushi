import 'package:sushi_sql/model/recipe_row.dart';

class Recipe {
  int id = 0;
  String name = '';
  List<RecipeRow> RecipeRows = [];

  Recipe(this.id, this.name, this.RecipeRows);
  Recipe.empty() {
    id = 0;
    name = '';
    RecipeRows = [];
  }

  // Метод для создания экземпляра из Map
  factory Recipe.fromMap(Map<dynamic, dynamic> map) {
    return Recipe(map['id'] ?? 0, map['name'] ?? '', map['RecipeRows'] ?? []);
  }

  // Метод для преобразования экземпляра в Map
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'RecipeRows': RecipeRows};
  }

  @override
  String toString() {
    return 'Recipe {id = $id, name = $name, RecipeRows = $RecipeRows }';
  }
}
