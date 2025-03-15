import 'package:flutter/material.dart';
import 'package:sushi_sql/form/ingridient_add_edit_form.dart';
import 'package:sushi_sql/form/ingridient_form.dart';
import 'package:sushi_sql/form/recipe_add_edit_form.dart';
import 'package:sushi_sql/form/recipe_form.dart';
import 'package:sushi_sql/form/recipe_row_add_edit.dart';
import 'package:sushi_sql/model/ingridient.dart';
import 'package:sushi_sql/model/recipe.dart';
import 'package:sushi_sql/model/recipe_row.dart';

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

      case RecipeForm.route:
        return MaterialPageRoute(builder: (context) => RecipeForm());

      case RecipeAddEditForm.route:
        // final Recipe recipe = routeSettings.arguments as Recipe;
        return MaterialPageRoute(builder: (context) => RecipeAddEditForm());

      case RecipeRowAddEdit.route:
        final RecipeRow recipe_row = routeSettings.arguments as RecipeRow;
        return MaterialPageRoute(
          builder: (context) => RecipeRowAddEdit(recipeRow: recipe_row),
        );

      default:
        return MaterialPageRoute(builder: (context) => RecipeForm());
    }
  }
}
