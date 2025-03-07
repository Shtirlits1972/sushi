import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sushi_sql/controller/ingridient_controller.dart';
import 'package:sushi_sql/crud/ingridient_crud.dart';
import 'package:sushi_sql/form/ingridient_add_edit_form.dart';
import 'package:sushi_sql/model/ingridient.dart';
import 'package:sushi_sql/widget/driwer.dart';
import 'package:sushi_sql/widget/snack_bar.dart';

class IngridientForm extends StatefulWidget {
  IngridientForm({Key? key}) : super(key: key);

  static const String route = '/IngridientForm';

  @override
  _IngridientFormState createState() => _IngridientFormState();
}

class _IngridientFormState extends State<IngridientForm> {
  // List<Ingridient> list = [];
  final IngridientController controllerGetX = Get.put(IngridientController());

  @override
  void initState() {
    super.initState();
    IngridientCrud.getAll().then((value) {
      controllerGetX.setIngridient(value);
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
        title: Text('Ingridients'),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                IngridientAddEditForm.route,
                arguments: Ingridient.empty(),
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
              controllerGetX.ingridients.isEmpty
                  ? Text('No Data')
                  : ListView.separated(
                    separatorBuilder:
                        (context, index) => const Divider(thickness: 1),
                    itemCount: controllerGetX.ingridients.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: (direction) async {
                          await IngridientCrud.del(
                            controllerGetX.ingridients[index].id,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBarOK(
                              '${controllerGetX.ingridients[index].name} is deleted!',
                            ),
                          );

                          print('remuve: ${controllerGetX.ingridients[index]}');
                          setState(() {
                            controllerGetX.removeIngridient(
                              controllerGetX.ingridients[index].id,
                            );
                          });
                        },
                        key: Key(
                          controllerGetX.ingridients[index].id.toString(),
                        ),
                        child: InkWell(
                          onLongPress: () {
                            Navigator.pushNamed(
                              context,
                              IngridientAddEditForm.route,
                              arguments: controllerGetX.ingridients[index],
                            );
                          },
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  '${controllerGetX.ingridients[index].id}',
                                ),
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(
                              '${controllerGetX.ingridients[index].name}',
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
