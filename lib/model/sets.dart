import 'package:sushi_sql/model/sets_row.dart';

class Sets {
  int id = 0;
  String name = '';
  List<SetsRow> setsRow = [];

  Sets(this.id, this.name, this.setsRow);
  Sets.empty() {
    id = 0;
    name = '';
    setsRow = [];
  }

  // Метод для создания экземпляра из Map
  factory Sets.fromMap(Map<dynamic, dynamic> map) {
    return Sets(
      map['id'] ?? 0,
      map['name'] ?? '',
      map['setsRow'] ?? [],
    );
  }

  // Метод для преобразования экземпляра в Map
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  @override
  String toString() {
    return 'Sets {id = $id, name = $name}';
  }
}
