import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sushi_sql/controller/ingridient_controller.dart';
import 'package:sushi_sql/controller/recipe_controller.dart';
import 'package:sushi_sql/crud/ingridient_crud.dart';
import 'package:sushi_sql/crud/recipe_row_crud.dart';
import 'package:sushi_sql/model/recipe_row.dart';
import 'package:sushi_sql/widget/item_widget.dart';

class RecipeRowAddEdit extends StatefulWidget {
  RecipeRowAddEdit({Key? key, required this.recipeRow}) : super(key: key);

  RecipeRow recipeRow;
  static const String route = '/RecipeRowAddEdit';

  @override
  _RecipeRowAddEditState createState() => _RecipeRowAddEditState();
}

class _RecipeRowAddEditState extends State<RecipeRowAddEdit> {
  final IngridientController ingridientGetX = Get.put(IngridientController());
  final RecipeController recipeGetX = Get.put(RecipeController());

  @override
  void initState() {
    super.initState();
    IngridientCrud.getAll().then((value) {
      ingridientGetX.setIngridient(value);

      if (widget.recipeRow.ingridientId == 0) {
        widget.recipeRow.ingridientId = ingridientGetX.ingridients.first.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController weightController = TextEditingController(
      text: widget.recipeRow.weight.toString(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingridients'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Obx(() {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      hintText: 'Enyer weight', // Подсказка
                      border: OutlineInputBorder(), // Граница
                    ),
                  ),
                ),
              ),

              Flexible(
                flex: 8,
                child: ListView.separated(
                  separatorBuilder:
                      (context, index) => const Divider(thickness: 1),
                  itemCount: ingridientGetX.ingridients.length,
                  itemBuilder: (context, index) {
                    return RadioMenuButton(
                      child: Text(ingridientGetX.ingridients[index].name),
                      value: ingridientGetX.ingridients[index].id,
                      groupValue: widget.recipeRow.ingridientId,
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          widget.recipeRow.ingridientId = value!;
                          widget.recipeRow.name =
                              ingridientGetX.ingridients[index].name;
                          widget.recipeRow.weight = double.parse(
                            weightController.text,
                          );
                        });
                      },
                    );
                  },
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    //   color: Theme.of(context).primaryColor, // Фоновый цвет
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                    ),
                    //  borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //===================== ( OK ) ========================
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () {
                              var f = 0;
                              double weight = double.parse(
                                weightController.text,
                              );

                              RecipeRow row = RecipeRow(
                                widget.recipeRow.id,
                                widget.recipeRow.recipeId,
                                widget.recipeRow.ingridientId,
                                widget.recipeRow.name,
                                weight,
                              );
                              print(row);

                              if (widget.recipeRow.id == 0) {
                                RecipeRowCrud.add(row).then((val) {
                                  var t2 = 0;
                                  recipeGetX.updateRow(val);

                                  Navigator.pop(context);
                                });
                              } else {
                                RecipeRowCrud.edit(row).then((val) {
                                  var t3 = 0;
                                  recipeGetX.updateRow(val);

                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Text('OK'),
                          ),
                        ),
                        //===================== ( OK ) ========================
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
