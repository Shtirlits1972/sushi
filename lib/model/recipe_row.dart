class RecipeRow {
  int id = 0;
  int recipeId = 0;
  int ingridientId = 0;
  String name = '';
  double weight = 0;

  RecipeRow(this.id, this.recipeId, this.ingridientId, this.name, this.weight);

  RecipeRow.empty() {
    id = 0;
    recipeId = 0;
    ingridientId = 0;
    name = '';
    weight = 0;
  }

  // Метод для создания экземпляра из Map
  factory RecipeRow.fromMap(Map<dynamic, dynamic> map) {
    return RecipeRow(
      map['id'] ?? 0,
      map['recipeId'] ?? 0,
      map['ingridientId'] ?? 0,
      map['name'] ?? '',
      map['weight'] ?? 0,
    );
  }

  // Метод для преобразования экземпляра в Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipeId': recipeId,
      'ingridientId': ingridientId,
      'name': name,
      'weight': weight,
    };
  }

  @override
  String toString() {
    return 'RecipeRow {id = $id, recipeId = $recipeId, ingridientId = $ingridientId, name = $name, weight = $weight }';
  }
}
