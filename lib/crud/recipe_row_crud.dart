import 'package:sqflite/sqflite.dart';
import 'package:sushi_sql/constants.dart';
import 'package:path/path.dart';
import 'package:sushi_sql/model/recipe_row.dart';

class RecipeRowCrud {
  // Кэшируем путь к базе данных, чтобы не вычислять его каждый раз
  static Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return openDatabase(path, version: 1);
  }

  static Future<RecipeRow> add(RecipeRow model) async {
    final db = await _getDatabase();
    try {
      RecipeRow reciperow = await db.transaction<RecipeRow>((txn) async {
        final id = await txn.rawInsert(
          'INSERT INTO [RecipeRow] (recipeId, ingridientId, weight) VALUES (?,?,?); ',
          [model.recipeId, model.ingridientId, model.weight],
        );
        return RecipeRow(
          id,
          model.recipeId,
          model.ingridientId,
          model.name,
          model.weight,
        );
      });
      return reciperow;
    } catch (e) {
      print('Ошибка при добавлении рецепта: $e');
      rethrow; // Повторно выбрасываем исключение, чтобы обработать его на уровне выше
    } finally {
      await db.close();
    }
  }

  static Future del(int id) async {
    String command = 'DELETE FROM [RecipeRow] WHERE id = ?';
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

  static Future delByRecipeId(int recipeId) async {
    String command = 'DELETE FROM [RecipeRow] WHERE recipeId = ?';
    final db = await _getDatabase();
    try {
      int count = await db.rawDelete(command, [recipeId]);
      print('row delete = $count ');
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
  }

  static Future<RecipeRow> edit(RecipeRow model) async {
    String command =
        'UPDATE [RecipeRow] SET recipeId = ?, ingridientId = ?, weight = ? WHERE id = ?';
    final db = await _getDatabase();
    try {
      int count = await db.rawUpdate(command, [
        model.recipeId,
        model.ingridientId,
        model.weight,
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

  static Future<List<RecipeRow>> getAll() async {
    List<RecipeRow> listRecipeRow = [];
    final db = await _getDatabase();

    try {
      List<Map> list = await db.rawQuery(
        'SELECT id, recipeId, ingridientId, [name], weight  FROM [RecipeRowView] ',
      );

      for (int i = 0; i < list.length; i++) {
        RecipeRow pr = RecipeRow.fromMap(list[i]);
        listRecipeRow.add(pr);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
    return listRecipeRow;
  }

  static Future<List<RecipeRow>> getByRecipeId(int recipeId) async {
    List<RecipeRow> listRecipeRow = [];
    final db = await _getDatabase();

    try {
      List<Map> list = await db.rawQuery(
        'SELECT id, recipeId, ingridientId, [name], weight  FROM [RecipeRowView] WHERE recipeId = ? ;',
        [recipeId],
      );

      for (int i = 0; i < list.length; i++) {
        RecipeRow pr = RecipeRow.fromMap(list[i]);
        listRecipeRow.add(pr);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
    return listRecipeRow;
  }
}
