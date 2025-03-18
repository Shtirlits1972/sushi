import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sushi_sql/controller/recipe_controller.dart';
import 'package:sushi_sql/controller/sets_controller.dart';
import 'package:sushi_sql/crud/recipe_crud.dart';
import 'package:sushi_sql/crud/sets_row_crud.dart';
import 'package:sushi_sql/model/sets.dart';
import 'package:sushi_sql/model/sets_row.dart';

class SetsRowAddEditForm extends StatefulWidget {
  SetsRowAddEditForm({Key? key, required this.setsRow}) : super(key: key);

  static const String route = '/RecipeSelectForm';
  SetsRow setsRow;

  @override
  _SetsRowAddEditFormState createState() => _SetsRowAddEditFormState();
}

class _SetsRowAddEditFormState extends State<SetsRowAddEditForm> {
  final SetsController setsGetX = Get.put(SetsController());
  final RecipeController recipeController = Get.put(RecipeController());
  final recipeGetX = Get.put(RecipeController());

  @override
  void initState() {
    super.initState();
    RecipeCrud.getAll().then((value) {
      recipeController.setRecipeList(value);
      //  если добавляем - то добавляем id и name
      if (widget.setsRow.recipeId == 0) {
        widget.setsRow.recipeId = recipeGetX.recipes.first.id;
        widget.setsRow.name = recipeGetX.recipes.first.name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController weightController = TextEditingController(
      text: widget.setsRow.amount.toString(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Recepts'),
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
                      hintText: 'Enyer amount', // Подсказка
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
                  itemCount: recipeGetX.recipes.length,
                  itemBuilder: (context, index) {
                    return RadioMenuButton(
                      child: Text(recipeGetX.recipes[index].name),
                      value: recipeGetX.recipes[index].id,
                      groupValue: widget.setsRow.recipeId,
                      onChanged: (value) {
                        //=================  onChanged  ===========================
                        print(value);
                        setState(() {
                          widget.setsRow.recipeId = value!;
                          widget.setsRow.name = recipeGetX.recipes[index].name;

                          var amount = int.tryParse(weightController.text);
                          print(amount);
                          var t = 0;
                          widget.setsRow.amount = (amount != null) ? amount : 0;
                          print(widget.setsRow);
                        });
                        //=================  onChanged  ===========================
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
                            onPressed: () async {
                              var f = 0;
                              var parsed = int.tryParse(weightController.text);

                              int amount = parsed != null ? parsed : 0;

                              SetsRow row = SetsRow(
                                widget.setsRow.id,
                                widget.setsRow.setsId,
                                widget.setsRow.recipeId,
                                widget.setsRow.name,
                                amount,
                              );

                              print(row);

                              var f3 = 0;

                              if (widget.setsRow.id == 0) {
                                row = await SetsRowCrud.add(row);
                              } else {
                                row = await SetsRowCrud.edit(row);
                              }

                              var t3 = 0;
                              setsGetX.addOrUpdateSetsRows(row);
                              Navigator.pop(context);
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
