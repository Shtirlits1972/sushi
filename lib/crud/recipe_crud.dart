import 'package:sqflite/sqflite.dart';
import 'package:sushi_sql/constants.dart';
import 'package:path/path.dart';
import 'package:sushi_sql/crud/recipe_row_crud.dart';
import 'package:sushi_sql/model/recipe.dart';
import 'package:sushi_sql/model/recipe_row.dart';

class RecipeCrud {
  // Кэшируем путь к базе данных, чтобы не вычислять его каждый раз
  static Future<Database> _getDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return openDatabase(path, version: 1);
  }

  static Future<Recipe> add(Recipe model) async {
    final db = await _getDatabase();
    try {
      Recipe recipe = await db.transaction<Recipe>((txn) async {
        final id = await txn.rawInsert(
          'INSERT INTO [Recipe] (name) VALUES (?);',
          [model.name],
        );
        return Recipe(id, model.name, []);
      });
      return recipe;
    } catch (e) {
      print('Ошибка при добавлении рецепта: $e');
      rethrow; // Повторно выбрасываем исключение, чтобы обработать его на уровне выше
    } finally {
      await db.close();
    }
  }

  static Future del(int id) async {
    String command = 'DELETE FROM [Recipe] WHERE id = ?';
    final db = await _getDatabase();
    try {
      RecipeRowCrud.delByRecipeId(id).then((val) async {
        int count = await db.rawDelete(command, [id]);
        print('row delete = $count ');
      });
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
  }

  static Future<Recipe> edit(Recipe model) async {
    String command = 'UPDATE [Recipe] SET [name] = ? WHERE id = ?';
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

  static Future<List<Recipe>> getAll() async {
    List<Recipe> listRecipe = [];
    final db = await _getDatabase();

    try {
      List<Map> list = await db.rawQuery('SELECT id, [name] FROM [Recipe] ;');

      List<RecipeRow> recipeRow = await RecipeRowCrud.getAll();

      for (int i = 0; i < list.length; i++) {
        Recipe recipe = Recipe.fromMap(list[i]);

        for (int j = 0; j < recipeRow.length; j++) {
          if (recipeRow[j].recipeId == recipe.id) {
            recipe.RecipeRows.add(recipeRow[j]);
          }
        }

        listRecipe.add(recipe);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      await db.close();
    }
    return listRecipe;
  }
}
