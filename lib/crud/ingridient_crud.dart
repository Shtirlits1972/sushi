import 'package:sqflite/sqflite.dart';
import 'package:sushi_sql/constants.dart';
import 'package:sushi_sql/model/ingridient.dart';
import 'package:path/path.dart';

class IngridientCrud {
  // Кэшируем путь к базе данных, чтобы не вычислять его каждый раз
  static Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return openDatabase(path, version: 1);
  }

  static Future<Ingridient> add(Ingridient model) async {
    final db = await _getDatabase();
    try {
      Ingridient ingridient = await db.transaction<Ingridient>((txn) async {
        final id = await txn.rawInsert(
          'INSERT INTO [Ingridient] (name) VALUES (?);',
          [model.name],
        );
        return Ingridient(id, model.name);
      });
      return ingridient;
    } catch (e) {
      print('Ошибка при добавлении ингредиента: $e');
      rethrow; // Повторно выбрасываем исключение, чтобы обработать его на уровне выше
    } finally {
      await db.close();
    }
  }

  static Future del(int id) async {
    String command = 'DELETE FROM [Ingridient] WHERE id = ?';
    final db = await _getDatabase();
    try {
      int count = await db.rawDelete(command, [id]);
      print('row delete = $count ');
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
  }

  static Future<Ingridient> edit(Ingridient model) async {
    String command = 'UPDATE [Ingridient] SET [name] = ? WHERE id = ?';
    final db = await _getDatabase();
    try {
      int count = await db.rawUpdate(command, [model.name, model.id]);
      print('row updated = $count ');
      return model;
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
  }

  static Future<List<Ingridient>> getAll() async {
    List<Ingridient> listIngridient = [];
    final db = await _getDatabase();

    try {
      List<Map> list = await db.rawQuery(
        'SELECT id, [name] FROM [Ingridient] ;',
      );

      for (int i = 0; i < list.length; i++) {
        Ingridient pr = Ingridient.fromMap(list[i]);
        listIngridient.add(pr);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
    return listIngridient;
  }
}
