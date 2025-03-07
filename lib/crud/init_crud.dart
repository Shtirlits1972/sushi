import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sushi_sql/constants.dart';

class InitCrud {
  static init() async {
    String IngridientTab =
        'CREATE TABLE [Ingridient](  [id] INTEGER PRIMARY KEY AUTOINCREMENT,  [name] NVARCHAR );  ';

    getDatabasesPath().then((String strPath) {
      String path = join(strPath, dbName);
      try {
        final database = openDatabase(
          path,
          onCreate: (db, version) async {
            await db.execute(IngridientTab);

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
