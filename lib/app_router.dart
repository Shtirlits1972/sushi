import 'package:flutter/material.dart';
import 'package:sushi_sql/form/ingridient_add_edit_form.dart';
import 'package:sushi_sql/form/ingridient_form.dart';
import 'package:sushi_sql/model/ingridient.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case IngridientForm.route:
        return MaterialPageRoute(builder: (context) => IngridientForm());

      case IngridientAddEditForm.route:
        final Ingridient ingridient = routeSettings.arguments as Ingridient;
        return MaterialPageRoute(
          builder: (context) => IngridientAddEditForm(model: ingridient),
        );

      default:
        return MaterialPageRoute(builder: (context) => IngridientForm());
    }
  }
}
