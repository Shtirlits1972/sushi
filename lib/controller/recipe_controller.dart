import 'package:get/get.dart';
import 'package:sushi_sql/model/recipe.dart';
import 'package:sushi_sql/model/recipe_row.dart';

class RecipeController extends GetxController {
  // Реактивный список
  var recipes = <Recipe>[].obs;
  Rx<Recipe> recipeEdit = Recipe.empty().obs;

  Rx<Recipe> get getRegipeEdit => recipeEdit;

  setRecipeEdit(Recipe newRecipe) {
    recipeEdit.value = newRecipe;
  }

  addUpdateRecipeEditRows(RecipeRow row) {
    bool flag = true;

    for (int i = 0; i < recipeEdit.value.RecipeRows.length; i++) {
      if (recipeEdit.value.RecipeRows[i].id == row.id) {
        recipeEdit.value.RecipeRows[i] = row;
        flag = false;
        break;
      }
    }

    if (flag) {
      recipeEdit.value.RecipeRows.add(row);
    }

    addOrUpdateRecipe(recipeEdit.value);
  }

  //=================================================================================
  setRecipeList(List<Recipe> newList) {
    recipes.value = newList;
  }

  // Добавить
  // void addRecipeToList(Recipe Recipe) {
  //   recipes.add(Recipe);
  // }

  // Удалить  по id
  void removeRecipe(int id) {
    recipes.removeWhere((item) => item.id == id);
  }

  Recipe getRecipeById(int id) {
    return recipes.firstWhere((item) => item.id == id);
  }

  //  обновить RecipeRow
  void updateRecipeRow(RecipeRow row) {
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
  void addOrUpdateRecipe(Recipe newRecipe) {
    bool flag = true;
    for (int i = 0; i < recipes.length; i++) {
      if (recipes[i].id == newRecipe.id) {
        recipes[i] = newRecipe;
        flag = false;
        break;
      }
    }
    if (flag) {
      recipes.add(newRecipe);
    }
  }

  // Очистить список
  void clearRecipes() {
    recipes.clear();
  }
}
