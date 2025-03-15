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
import 'package:sushi_sql/widget/pick_image.dart';
import 'package:sushi_sql/widget/snack_bar.dart';

class RecipeAddEditForm extends StatefulWidget {
  RecipeAddEditForm({Key? key}) : super(key: key);

  static const String route = '/RecipeAddEditForm';

  @override
  _RecipeAddEditFormState createState() => _RecipeAddEditFormState();
}

class _RecipeAddEditFormState extends State<RecipeAddEditForm> {
  final RecipeController recipeGetX = Get.put(RecipeController());
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = recipeGetX.getRegipeEdit.value.name;
    print(recipeGetX.getRegipeEdit);
    var f33 = 0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Recipe'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              if (recipeGetX.getRegipeEdit.value.id == 0) {
                recipeGetX.getRegipeEdit.value.name = nameController.text;
                RecipeCrud.add(recipeGetX.getRegipeEdit.value).then((
                  val,
                ) async {
                  recipeGetX.setRecipeEdit(val);
                  print('RecipeEdit = $val');
                  var f = 0;
                  recipeGetX.addOrUpdateRecipe(val);

                  await Navigator.pushNamed(
                    context,
                    RecipeRowAddEdit.route,
                    arguments: RecipeRow(
                      0,
                      recipeGetX.getRegipeEdit.value.id,
                      0,
                      '',
                      0,
                    ),
                  );

                  setState(() {});
                  var cc = 0;
                });
              } else {
                await Navigator.pushNamed(
                  context,
                  RecipeRowAddEdit.route,
                  arguments: RecipeRow(
                    0,
                    recipeGetX.getRegipeEdit.value.id,
                    0,
                    '',
                    0,
                  ),
                );
                // print('row = $row');
                setState(() {});
              }
            },
            icon: Icon(Icons.add_circle_rounded),
          ),
        ],
      ),

      body: Obx(() {
        var recipe = recipeGetX.getRegipeEdit;
        print(recipe);
        var d3 = 0;
        return Column(
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
                    child: Column(
                      children: [
                        (recipeGetX.getRegipeEdit.value.image != null)
                            ? Expanded(
                              child: Image.memory(
                                recipeGetX.getRegipeEdit.value.image!,
                                // width: 50,
                                height: 50,
                              ),
                            )
                            : Expanded(
                              child: Image.asset('assets/images/no_photo.png'),
                            ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                var img = await pickImage();

                                if (img != null) {
                                  setState(() {
                                    recipeGetX.getRegipeEdit.value.image = img;
                                  });
                                }
                                var t2 = 0;
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                print('delete');
                                recipeGetX.getRegipeEdit.value.image = null;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,

                    child: ListView.separated(
                      separatorBuilder:
                          (context, index) => const Divider(thickness: 1),
                      itemCount:
                          recipeGetX.getRegipeEdit.value.RecipeRows.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          onDismissed: (direction) async {
                            try {
                              RecipeRowCrud.del(
                                recipeGetX
                                    .getRegipeEdit
                                    .value
                                    .RecipeRows[index]
                                    .id,
                              ).then((value) {
                                setState(() {
                                  recipeGetX.getRegipeEdit.value.RecipeRows
                                      .removeWhere(
                                        (item) =>
                                            item.id ==
                                            recipeGetX
                                                .getRegipeEdit
                                                .value
                                                .RecipeRows[index]
                                                .id,
                                      );
                                  recipeGetX.addOrUpdateRecipe(
                                    recipeGetX.getRegipeEdit.value,
                                  );
                                  //   setState(() {});
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  snackBarOK(
                                    '${recipeGetX.getRegipeEdit.value.RecipeRows[index].name} is deleted!',
                                  ),
                                );
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          key: Key(
                            recipeGetX.getRegipeEdit.value.RecipeRows[index].id
                                .toString(),
                          ),
                          child: InkWell(
                            onLongPress: () {
                              Navigator.pushNamed(
                                context,
                                RecipeRowAddEdit.route,
                                arguments:
                                    recipeGetX
                                        .getRegipeEdit
                                        .value
                                        .RecipeRows[index],
                              ).then((val) {
                                setState(() {});
                              });
                            },
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text('${index + 1}'),
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              title: Text(
                                '${recipeGetX.getRegipeEdit.value.RecipeRows[index].name}',
                                style: const TextStyle(fontSize: 20),
                              ),

                              trailing: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${recipeGetX.getRegipeEdit.value.RecipeRows[index].weight}',
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
                              showAlertDialog(context, 'enter recipe name!');
                            } else {
                              recipeGetX.getRegipeEdit.value.name =
                                  nameController.text;
                              if (recipeGetX.getRegipeEdit.value.id == 0) {
                                var g3 = 0;
                                RecipeCrud.add(
                                  recipeGetX.getRegipeEdit.value,
                                ).then((value) {
                                  recipeGetX.addOrUpdateRecipe(value);
                                  recipeGetX.setRecipeEdit(Recipe.empty());
                                  Navigator.pop(context);
                                });
                              } else {
                                RecipeCrud.edit(
                                  recipeGetX.getRegipeEdit.value,
                                ).then((value) {
                                  recipeGetX.addOrUpdateRecipe(value);
                                  recipeGetX.setRecipeEdit(Recipe.empty());
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
        );
      }),
    );
  }
}
