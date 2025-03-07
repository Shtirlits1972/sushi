import 'package:get/get.dart';
import 'package:sushi_sql/model/ingridient.dart';

class IngridientController extends GetxController {
  // Реактивный список ингредиентов
  var ingridients = <Ingridient>[].obs;

  setIngridient(List<Ingridient> newList) {
    ingridients.value = newList;
  }

  // Добавить ингредиент
  void addIngridient(Ingridient ingridient) {
    ingridients.add(ingridient);
  }

  // Удалить ингредиент по id
  void removeIngridient(int id) {
    ingridients.removeWhere((item) => item.id == id);
  }

  // Обновить ингредиент
  void updateIngridient(Ingridient newIngridient) {
    for (int i = 0; i < ingridients.length; i++) {
      var t = 0;
      if (ingridients[i].id == newIngridient.id) {
        ingridients[i] = newIngridient;
        break;
      }
    }
  }

  // Очистить список
  void clearIngridients() {
    ingridients.clear();
  }
}
