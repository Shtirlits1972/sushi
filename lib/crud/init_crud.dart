import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sushi_sql/constants.dart';

class InitCrud {
  static init() async {
    String IngridientTab =
        'CREATE TABLE [Ingridient](  [id] INTEGER PRIMARY KEY AUTOINCREMENT,  [name] NVARCHAR );  ';

    String RecipeTab =
        'CREATE TABLE [Recipe] ( [id] INTEGER PRIMARY KEY AUTOINCREMENT,  [name] NVARCHAR,  [image] BLOB );   ';

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

    String setsTable =
        'CREATE TABLE [Sets](  [id] INTEGER PRIMARY KEY AUTOINCREMENT, [name] NVARCHAR );  ';

    String SetsRowT =
        '      CREATE TABLE [SetsRow](  ' +
        ' [id] INTEGER PRIMARY KEY AUTOINCREMENT,  ' +
        ' [setsId] NOT NULL REFERENCES [Sets]([id]), ' +
        ' [recipeId] NOT NULL REFERENCES [Recipe]([id]), ' +
        ' [amount] INTEGER DEFAULT 0,  ' +
        ' UNIQUE([setsId], [recipeId] ) ' +
        ' ); ';

    String SetsRowView =
        ' CREATE VIEW SetsRowView AS ' +
        ' SELECT  ' +
        '  S.[id] ,  ' +
        '   S.[setsId] ,  ' +
        '   S.[recipeId] ,  ' +
        '   S.[amount], ' +
        '   R.name   ' +
        '   FROM  ' +
        ' SetsRow  S ' +
        ' LEFT JOIN Recipe R ON S.recipeId = R.id;  ';

    String ingridient_1 =
        'INSERT INTO Ingridient ([name]) VALUES ("картошка");';
    String ingridient_2 = 'INSERT INTO Ingridient ([name]) VALUES ("лосось");';
    String ingridient_3 = 'INSERT INTO Ingridient ([name]) VALUES ("огурец");';
    String ingridient_31 =
        'INSERT INTO Ingridient ([name]) VALUES ("помидор");';
    String ingridient_4 = 'INSERT INTO Ingridient ([name]) VALUES ("рис");';
    String ingridient_5 = 'INSERT INTO Ingridient ([name]) VALUES ("оливки");';
    String ingridient_6 =
        'INSERT INTO Ingridient ([name]) VALUES ("сыр пармезан");';
    String ingridient_7 = 'INSERT INTO Ingridient ([name]) VALUES ("нори");';

    String ingridient_8 = 'INSERT INTO Ingridient ([name]) VALUES ("кетчуп");';
    String ingridient_9 = 'INSERT INTO Ingridient ([name]) VALUES ("мука");';
    String ingridient_10 =
        'INSERT INTO Ingridient ([name]) VALUES ("колбаса");';
    String ingridient_11 =
        'INSERT INTO Ingridient ([name]) VALUES ("мясо краба");';

    getDatabasesPath().then((String strPath) {
      String path = join(strPath, dbName);
      try {
        final database = openDatabase(
          path,
          onCreate: (db, version) async {
            await db.execute(IngridientTab);
            //--------------------------------------
            await db.execute(RecipeTab);
            await db.execute(RecipeRow);
            await db.execute(RecipeRowView);
            //--------------------------------------
            await db.execute(setsTable);
            await db.execute(SetsRowT);
            await db.execute(SetsRowView);
            //======================================
            await db.execute(ingridient_1);
            await db.execute(ingridient_2);
            await db.execute(ingridient_3);
            await db.execute(ingridient_31);
            await db.execute(ingridient_4);
            await db.execute(ingridient_5);
            await db.execute(ingridient_6);
            await db.execute(ingridient_7);
            await db.execute(ingridient_8);
            await db.execute(ingridient_9);
            await db.execute(ingridient_10);
            await db.execute(ingridient_11);
            //==========================================

            print('DB created');
          },
          version: 1,
        );
      } catch (e) {
        print(e);
        int y = 0;
      }
    });
  }
}
