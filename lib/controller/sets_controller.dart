import 'package:get/get.dart';
import 'package:sushi_sql/model/sets.dart';
import 'package:sushi_sql/model/sets_row.dart';

class SetsController extends GetxController {
  // Реактивный список
  var set_list = <Sets>[].obs;
  // редактируемый сет
  Rx<Sets> setsEdit = Sets.empty().obs;

  Rx<Sets> get getSetsEdit => setsEdit;

  setSetsEdit(Sets newSets) {
    setsEdit.value = newSets;
  }

  addOrUpdateSetsRows(SetsRow setsRow) {
    bool flag = true;

    for (int i = 0; i < setsEdit.value.setsRow.length; i++) {
      if (setsEdit.value.setsRow[i].id == setsRow.id) {
        setsEdit.value.setsRow[i] = setsRow;
        flag = false;
        break;
      }
    }
    if (flag) {
      setsEdit.value.setsRow.add(setsRow);
    }
  }

  //=========================================================================================

  setSets(List<Sets> newList) {
    set_list.value = newList;
  }

  // Удалить ингредиент по id
  void removeSets(int id) {
    set_list.removeWhere((item) => item.id == id);
  }

  // Обновить
  void addOrUpdateSets(Sets newSets) {
    bool flag = true;
    for (int i = 0; i < set_list.length; i++) {
      if (set_list[i].id == newSets.id) {
        set_list[i] = newSets;
        flag = false;
        break;
      }
    }

    if (flag) {
      set_list.add(newSets);
    }
  }

  // Очистить список
  void clearSetss() {
    set_list.clear();
  }
}
