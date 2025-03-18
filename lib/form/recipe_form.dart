import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sushi_sql/controller/recipe_controller.dart';
import 'package:sushi_sql/crud/recipe_crud.dart';
import 'package:sushi_sql/form/recipe_add_edit_form.dart';
import 'package:sushi_sql/model/recipe.dart';
import 'package:sushi_sql/widget/driwer.dart';
import 'package:sushi_sql/widget/item_widget.dart';
import 'package:sushi_sql/widget/snack_bar.dart';
import 'package:image_picker/image_picker.dart';

class RecipeForm extends StatefulWidget {
  RecipeForm({Key? key}) : super(key: key);

  static const String route = '/RecipeForm';

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  // List<Recipe> list = [];
  final RecipeController recipeGetX = Get.put(RecipeController());

  @override
  void initState() {
    super.initState();
    RecipeCrud.getAll().then((value) {
      recipeGetX.setRecipeList(value);
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
              Navigator.pushNamed(context, RecipeAddEditForm.route);
              recipeGetX.setRecipeEdit(Recipe.empty());
            },
            icon: Icon(Icons.add_circle_rounded),
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: Obx(() {
        return Center(
          child:
              recipeGetX.recipes.isEmpty
                  ? Text('No Data')
                  : ListView.separated(
                    separatorBuilder:
                        (context, index) => const Divider(thickness: 1),
                    itemCount: recipeGetX.recipes.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: (direction) {
                          String name = recipeGetX.recipes[index].name;

                          RecipeCrud.del(recipeGetX.recipes[index].id);

                          setState(() {
                            recipeGetX.removeRecipe(
                              recipeGetX.recipes[index].id,
                            );
                          });

                          print('remuve: $name');
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(snackBarOK('$name is deleted!'));
                        },
                        key: Key(recipeGetX.recipes[index].id.toString()),
                        child: InkWell(
                          onLongPress: () async {
                            recipeGetX.setRecipeEdit(recipeGetX.recipes[index]);
                            await Navigator.pushNamed(
                              context,
                              RecipeAddEditForm.route,
                            );
                          },
                          child: ExpansionTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text('${recipeGetX.recipes[index].id}'),
                              ),
                            ),
                            // contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              '${recipeGetX.recipes[index].name}',
                              style: const TextStyle(fontSize: 24),
                            ),
                            children: [
                              SizedBox(
                                height:
                                    (recipeGetX
                                            .recipes[index]
                                            .RecipeRows
                                            .length *
                                        70),
                                child: ListView.separated(
                                  separatorBuilder:
                                      (context, index2) =>
                                          const Divider(thickness: 1),
                                  itemCount:
                                      recipeGetX
                                          .recipes[index]
                                          .RecipeRows
                                          .length,
                                  itemBuilder: (context, index2) {
                                    return ListTile(
                                      title: Text(
                                        recipeGetX
                                            .recipes[index]
                                            .RecipeRows[index2]
                                            .name,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      trailing: Text(
                                        '${recipeGetX.recipes[index].RecipeRows[index2].weight}',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // const Divider(thickness: 1),
                              Container(
                                child:
                                    recipeGetX.recipes[index].image != null
                                        ? ExpansionTile(
                                          title: Text('image'),
                                          children: [
                                            Container(
                                              child: Image.memory(
                                                recipeGetX
                                                    .recipes[index]
                                                    .image!,
                                                height: 100,
                                              ),
                                            ),
                                          ],
                                        )
                                        : null,
                              ),
                            ],
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
