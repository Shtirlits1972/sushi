import 'package:sqflite/sqflite.dart';
import 'package:sushi_sql/constants.dart';
import 'package:path/path.dart';
import 'package:sushi_sql/model/sets_row.dart';

class SetsRowCrud {
  // Кэшируем путь к базе данных, чтобы не вычислять его каждый раз
  static Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return openDatabase(path, version: 1);
  }

  static Future<SetsRow> add(SetsRow model) async {
    final db = await _getDatabase();
    try {
      SetsRow setsrow = await db.transaction<SetsRow>((txn) async {
        final id = await txn.rawInsert(
          'INSERT INTO [SetsRow] (setsId, recipeId, amount) VALUES (?,?,?); ',
          [model.setsId, model.recipeId, model.amount],
        );
        var y = 0;
        return SetsRow(
          id,
          model.setsId,
          model.recipeId,
          model.name,
          model.amount,
        );
      });
      return setsrow;
    } catch (e) {
      print('Ошибка при добавлении сета: $e');
      rethrow; // Повторно выбрасываем исключение, чтобы обработать его на уровне выше
    } finally {
      await db.close();
    }
  }

  static Future del(int id) async {
    String command = 'DELETE FROM [SetsRow] WHERE id = ?';
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

  static Future<SetsRow> edit(SetsRow model) async {
    String command =
        'UPDATE [SetsRow] SET setsId = ?, recipeId = ?, amount = ? WHERE id = ?';
    final db = await _getDatabase();
    try {
      int count = await db.rawUpdate(command, [
        model.setsId,
        model.recipeId,
        model.amount,
        model.id,
      ]);
      print('row updated = $count ');
      return model;
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
  }

  static Future<List<SetsRow>> getAll() async {
    List<SetsRow> listSetsRow = [];
    final db = await _getDatabase();

    try {
      List<Map> list = await db.rawQuery(
        'SELECT id, setsId, recipeId, [name], amount  FROM [SetsRowView] ',
      );

      for (int i = 0; i < list.length; i++) {
        SetsRow pr = SetsRow.fromMap(list[i]);
        listSetsRow.add(pr);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
    return listSetsRow;
  }

  static Future<List<SetsRow>> getBySetsId(int recipeId) async {
    List<SetsRow> listSetsRow = [];
    final db = await _getDatabase();

    try {
      List<Map> list = await db.rawQuery(
        'SELECT id, setsId, recipeId, [name], amount   FROM [SetsRowView] WHERE setsId = ? ;',
        [recipeId],
      );

      for (int i = 0; i < list.length; i++) {
        SetsRow pr = SetsRow.fromMap(list[i]);
        listSetsRow.add(pr);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
    return listSetsRow;
  }
}
