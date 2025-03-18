import 'package:sqflite/sqflite.dart';
import 'package:sushi_sql/constants.dart';
import 'package:sushi_sql/crud/sets_row_crud.dart';
import 'package:sushi_sql/model/sets.dart';
import 'package:path/path.dart';
import 'package:sushi_sql/model/sets_row.dart';

class SetsCrud {
  // Кэшируем путь к базе данных, чтобы не вычислять его каждый раз
  static Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return openDatabase(path, version: 1);
  }

  static Future<Sets> add(Sets model) async {
    final db = await _getDatabase();
    try {
      return await db.transaction<Sets>((txn) async {
        final id = await txn.rawInsert(
          'INSERT INTO [Sets] (name) VALUES (?);',
          [model.name],
        );
        return Sets(id, model.name, []);
      });
    } catch (e) {
      print('Ошибка при добавлении : $e');
      rethrow; // Повторно выбрасываем исключение, чтобы обработать его на уровне выше
    } finally {
      await db.close();
    }
  }

  static Future del(int id) async {
    String deleteRows = 'DELETE FROM [SetsRow] WHERE recipeId = ? ;';

    String command = 'DELETE FROM [Sets] WHERE id = ?';
    final db = await _getDatabase();
    try {
      int count2 = await db.rawDelete(deleteRows, [id]);
      int count = await db.rawDelete(command, [id]);
      print('row delete = $count ');
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
  }

  static Future<Sets> edit(Sets model) async {
    String command = 'UPDATE [Sets] SET [name] = ? WHERE id = ?';
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

  static Future<List<Sets>> getAll() async {
    List<Sets> listSets = [];
    final db = await _getDatabase();

    try {
      List<Map> list = await db.rawQuery('SELECT id, [name] FROM [Sets] ;');

      List<SetsRow> setsRow = await SetsRowCrud.getAll();

      for (int i = 0; i < list.length; i++) {
        Sets set = Sets.fromMap(list[i]);
        for (int j = 0; j < setsRow.length; j++) {
          if (setsRow[j].setsId == set.id) {
            set.setsRow.add(setsRow[j]);
          }
        }
        listSets.add(set);
      }

      return listSets;
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
  }
}
