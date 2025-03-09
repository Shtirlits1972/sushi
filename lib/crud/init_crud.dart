import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sushi_sql/constants.dart';

class InitCrud {
  static init() async {
    String IngridientTab =
        'CREATE TABLE [Ingridient](  [id] INTEGER PRIMARY KEY AUTOINCREMENT,  [name] NVARCHAR );  ';

    String RecipeTab =
        'CREATE TABLE [Recipe]( [id] INTEGER PRIMARY KEY AUTOINCREMENT,  [name] NVARCHAR );   ';

    String RecipeRow =
        '      CREATE TABLE [RecipeRow](  ' +
        ' [id] INTEGER PRIMARY KEY AUTOINCREMENT,  ' +
        ' [recipeId] NOT NULL REFERENCES [Recipe]([id]), ' +
        ' [ingridientId] NOT NULL REFERENCES [Ingridient]([id]), ' +
        ' [weight] DOUBLE DEFAULT 0,  ' +
        ' UNIQUE([recipeId], [ingridientId]) ' +
        ' ); ';

    String RecipeRowView =
        ' CREATE VIEW RecipeRowView AS ' +
        ' SELECT  ' +
        '  R.[id] ,  ' +
        '   R.[recipeId] ,  ' +
        '   R.[ingridientId] ,  ' +
        '   R.[weight], ' +
        '   I.name   ' +
        '   FROM  ' +
        ' RecipeRow  R ' +
        ' LEFT JOIN Ingridient I ON I.id = R.ingridientId;  ';

    getDatabasesPath().then((String strPath) {
      String path = join(strPath, dbName);
      try {
        final database = openDatabase(
          path,
          onCreate: (db, version) async {
            await db.execute(IngridientTab);
            await db.execute(RecipeTab);

            await db.execute(RecipeRow);
            await db.execute(RecipeRowView);

            print('DB created');
          },
          version: 1,
        );
      } catch (e) {
        print(e);
      }
    });
  }
}
