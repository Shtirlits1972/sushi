class SetsRow {
  int id = 0;
  int setsId = 0;
  int recipeId = 0;
  String name = '';
  int amount = 0;

  SetsRow(this.id, this.setsId, this.recipeId, this.name, this.amount);

  SetsRow.empty() {
    id = 0;
    setsId = 0;
    recipeId = 0;
    name = '';
    amount = 0;
  }

  // Метод для создания экземпляра из Map
  factory SetsRow.fromMap(Map<dynamic, dynamic> map) {
    return SetsRow(
      map['id'] ?? 0,
      map['setsId'] ?? 0,
      map['recipeId'] ?? 0,
      map['name'] ?? '',
      map['amount'] ?? 0,
    );
  }

  // Метод для преобразования экземпляра в Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'setsId': setsId,
      'recipeId': recipeId,
      'name': name,
      'amount': amount,
    };
  }

  @override
  String toString() {
    return 'SetsRow { id = $id, setsId = $setsId, recipeId = $recipeId, name = $name, amount = $amount }';
  }
}
