import 'package:get/get.dart';
import 'package:sushi_sql/model/recipe.dart';
import 'package:sushi_sql/model/recipe_row.dart';

class RecipeController extends GetxController {
  // Реактивный список
  var recipes = <Recipe>[].obs;

  setRecipe(List<Recipe> newList) {
    recipes.value = newList;
  }

  // Добавить
  void addRecipe(Recipe Recipe) {
    recipes.add(Recipe);
  }

  // Удалить  по id
  void removeRecipe(int id) {
    recipes.removeWhere((item) => item.id == id);
  }

  //  обновить RecipeRow
  void updateRow(RecipeRow row) {
    for (int i = 0; i < recipes.value.length; i++) {
      var r = 0;
      if (recipes.value[i].id == row.recipeId) {
        bool flag = true;
        for (int j = 0; j < recipes.value[i].RecipeRows.length; j++) {
          if (recipes.value[i].RecipeRows[j].ingridientId == row.ingridientId) {
            recipes.value[i].RecipeRows[j] = row;
            flag = false;
            break;
          }
        }
        if (flag) {
          recipes.value[i].RecipeRows.add(row);
        }
      }
    }
  }

  // Обновить
  void updateRecipe(Recipe newRecipe) {
    for (int i = 0; i < recipes.length; i++) {
      if (recipes[i].id == newRecipe.id) {
        recipes[i] = newRecipe;
        break;
      }
    }
  }

  // Очистить список
  void clearRecipes() {
    recipes.clear();
  }
}
