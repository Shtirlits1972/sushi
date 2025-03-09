import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sushi_sql/controller/recipe_controller.dart';
import 'package:sushi_sql/crud/recipe_crud.dart';
import 'package:sushi_sql/crud/recipe_row_crud.dart';
import 'package:sushi_sql/form/recipe_row_add_edit.dart';
import 'package:sushi_sql/model/recipe.dart';
import 'package:sushi_sql/model/recipe_row.dart';
import 'package:sushi_sql/widget/alert.dart';
import 'package:sushi_sql/widget/driwer.dart';
import 'package:sushi_sql/widget/snack_bar.dart';

class RecipeAddEditForm extends StatefulWidget {
  RecipeAddEditForm({Key? key, required this.model}) : super(key: key);
  Recipe model;
  static const String route = '/RecipeAddEditForm';

  @override
  _RecipeAddEditFormState createState() => _RecipeAddEditFormState();
}

class _RecipeAddEditFormState extends State<RecipeAddEditForm> {
  final RecipeController recipeGetX = Get.put(RecipeController());
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(
      text: widget.model.name,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Recipe'),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                RecipeRowAddEdit.route,
                arguments: RecipeRow(0, widget.model.id, 0, '', 0),
              ).then((val) {
                setState(() {});
              });
            },
            icon: Icon(Icons.add_circle_rounded),
          ),
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 8,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Enyer recipe name', // Подсказка
                        border: OutlineInputBorder(), // Граница
                      ),
                    ),
                  ),
                ),

                Flexible(
                  flex: 1,

                  child: ListView.separated(
                    separatorBuilder:
                        (context, index) => const Divider(thickness: 1),
                    itemCount: widget.model.RecipeRows.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: (direction) async {
                          try {
                            RecipeRowCrud.del(
                              widget.model.RecipeRows[index].id,
                            ).then((value) {
                              setState(() {
                                widget.model.RecipeRows.removeWhere(
                                  (item) =>
                                      item.id ==
                                      widget.model.RecipeRows[index].id,
                                );
                                recipeGetX.updateRecipe(widget.model);
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBarOK(
                                  '${widget.model.RecipeRows[index].name} is deleted!',
                                ),
                              );
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        key: Key(widget.model.RecipeRows[index].id.toString()),
                        child: InkWell(
                          onLongPress: () {
                            Navigator.pushNamed(
                              context,
                              RecipeRowAddEdit.route,
                              arguments: widget.model.RecipeRows[index],
                            ).then((val) {
                              setState(() {});
                            });
                          },
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text('${index + 1}'),
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              '${widget.model.RecipeRows[index].name}',
                              style: const TextStyle(fontSize: 20),
                            ),

                            trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${widget.model.RecipeRows[index].weight}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: () {
                          //==//==//==//=================================================
                          if (nameController.text.trim().isEmpty) {
                            showAlertDialog(context, 'enter ingredient name');
                          } else {
                            widget.model.name = nameController.text;
                            if (widget.model.id == 0) {
                              RecipeCrud.add(widget.model).then((value) {
                                recipeGetX.addRecipe(value);
                                Navigator.pop(context);
                              });
                            } else {
                              RecipeCrud.edit(widget.model).then((value) {
                                recipeGetX.updateRecipe(value);
                                Navigator.pop(context);
                              });
                            }
                          }

                          //==//==//==//=================================================
                        },
                        child: Text('OK'),
                      ),
                    ),
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
  }
}
