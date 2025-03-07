class Ingridient {
  int id = 0;
  String name = '';

  Ingridient(this.id, this.name);
  Ingridient.empty() {
    id = 0;
    name = '';
  }

  // Метод для создания экземпляра из Map
  factory Ingridient.fromMap(Map<dynamic, dynamic> map) {
    return Ingridient(map['id'] ?? 0, map['name'] ?? '');
  }

  // Метод для преобразования экземпляра в Map
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'Ingridient {id = $id, name = $name}';
  }
}
