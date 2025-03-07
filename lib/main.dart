import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sushi_sql/app_router.dart';
import 'package:sushi_sql/crud/init_crud.dart';
import 'package:sushi_sql/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InitCrud.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp();
  final AppRouter _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _appRouter.onGenerateRoute,
      theme: lightTheme,
    );
  }
}
