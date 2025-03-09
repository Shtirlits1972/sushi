import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sushi_sql/controller/recipe_controller.dart';
import 'package:sushi_sql/crud/recipe_crud.dart';
import 'package:sushi_sql/form/recipe_add_edit_form.dart';
import 'package:sushi_sql/model/recipe.dart';
import 'package:sushi_sql/widget/driwer.dart';
import 'package:sushi_sql/widget/item_widget.dart';
import 'package:sushi_sql/widget/snack_bar.dart';

class RecipeForm extends StatefulWidget {
  RecipeForm({Key? key}) : super(key: key);

  static const String route = '/RecipeForm';

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  // List<Recipe> list = [];
  final RecipeController controllerGetX = Get.put(RecipeController());

  @override
  void initState() {
    super.initState();
    RecipeCrud.getAll().then((value) {
      controllerGetX.setRecipe(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        title: Text('Recipes'),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                RecipeAddEditForm.route,
                arguments: Recipe.empty(),
              );
            },
            icon: Icon(Icons.add_circle_rounded),
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: Obx(() {
        return Center(
          child:
              controllerGetX.recipes.isEmpty
                  ? Text('No Data')
                  : ListView.separated(
                    separatorBuilder:
                        (context, index) => const Divider(thickness: 1),
                    itemCount: controllerGetX.recipes.length,
                    itemBuilder: (context, index) {
                      //=========================================
                      List<ItemWidget> listItem = [];

                      for (
                        int i = 0;
                        i < controllerGetX.recipes[index].RecipeRows.length;
                        i++
                      ) {
                        listItem.add(
                          ItemWidget(
                            title:
                                controllerGetX
                                    .recipes[index]
                                    .RecipeRows[i]
                                    .name,
                            content:
                                '${controllerGetX.recipes[index].RecipeRows[i].weight}',
                          ),
                        );
                      }
                      //===============================================

                      return Dismissible(
                        onDismissed: (direction) async {
                          await RecipeCrud.del(
                            controllerGetX.recipes[index].id,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBarOK(
                              '${controllerGetX.recipes[index].name} is deleted!',
                            ),
                          );

                          print('remuve: ${controllerGetX.recipes[index]}');
                          setState(() {
                            controllerGetX.removeRecipe(
                              controllerGetX.recipes[index].id,
                            );
                          });
                        },
                        key: Key(controllerGetX.recipes[index].id.toString()),
                        child: InkWell(
                          onLongPress: () {
                            Navigator.pushNamed(
                              context,
                              RecipeAddEditForm.route,
                              arguments: controllerGetX.recipes[index],
                            ).then((val) {
                              setState(() {});
                            });
                          },
                          child: ExpansionTile(
                            children: listItem,
                            leading: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  '${controllerGetX.recipes[index].id}',
                                ),
                              ),
                            ),
                            // contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              '${controllerGetX.recipes[index].name}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        );
      }),
    );
  }
}
