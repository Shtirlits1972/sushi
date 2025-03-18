import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sushi_sql/controller/sets_controller.dart';
import 'package:sushi_sql/crud/sets_crud.dart';
import 'package:sushi_sql/form/sets_add_edit_form.dart';
import 'package:sushi_sql/model/sets.dart';
import 'package:sushi_sql/widget/driwer.dart';
import 'package:sushi_sql/widget/item_widget.dart';
import 'package:sushi_sql/widget/snack_bar.dart';

class SetsViewForm extends StatefulWidget {
  const SetsViewForm({Key? key}) : super(key: key);

  static const String route = '/SetsViewForm';

  @override
  _SetsViewFormState createState() => _SetsViewFormState();
}

class _SetsViewFormState extends State<SetsViewForm> {
  final SetsController controllerGetX = Get.put(SetsController());

  @override
  void initState() {
    super.initState();
    SetsCrud.getAll().then((value) {
      controllerGetX.set_list(value);
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
        title: Text('Sets'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SetsAddEditForm.route,
                arguments: Sets.empty(),
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
              controllerGetX.set_list.isEmpty
                  ? Text('No Data')
                  : ListView.separated(
                    separatorBuilder:
                        (context, index) => const Divider(thickness: 1),
                    itemCount: controllerGetX.set_list.length,
                    itemBuilder: (context, index) {
                      // List<Widget> listItem = [];

                      // for (
                      //   int i = 0;
                      //   i < controllerGetX.set_list[index].setsRow.length;
                      //   i++
                      // ) {
                      //   listItem.add(
                      //     ItemWidget(
                      //       title:
                      //           controllerGetX.set_list[index].setsRow[i].name,
                      //       content:
                      //           '${controllerGetX.set_list[index].setsRow[i].amount}',
                      //     ),
                      //   );
                      // }

                      return Dismissible(
                        onDismissed: (direction) async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBarOK(
                              '${controllerGetX.set_list[index].name} is deleted!',
                            ),
                          );

                          await SetsCrud.del(controllerGetX.set_list[index].id);

                          print('remuve: ${controllerGetX.set_list[index]}');
                          setState(() {
                            controllerGetX.removeSets(
                              controllerGetX.set_list[index].id,
                            );
                          });
                        },
                        key: Key(controllerGetX.set_list[index].id.toString()),
                        child: InkWell(
                          onLongPress: () async {
                            //  set edit
                            controllerGetX.setSetsEdit(
                              controllerGetX.set_list[index],
                            );
                            await Navigator.pushNamed(
                              context,
                              SetsAddEditForm.route,
                            );
                          },
                          child: ExpansionTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text('${index + 1}'),
                              ),
                            ),
                            dense: true,
                            title: Text(
                              '${controllerGetX.set_list[index].name}',
                              style: const TextStyle(fontSize: 20),
                            ),
                            children: [
                              //============================================
                              SizedBox(
                                height:
                                    (controllerGetX
                                            .set_list[index]
                                            .setsRow
                                            .length *
                                        70),
                                child: ListView.separated(
                                  separatorBuilder:
                                      (context, index2) =>
                                          const Divider(thickness: 1),
                                  itemCount:
                                      controllerGetX
                                          .set_list[index]
                                          .setsRow
                                          .length,
                                  itemBuilder: (context, index2) {
                                    return ListTile(
                                      // leading: Padding(
                                      //   padding: const EdgeInsets.all(4.0),
                                      //   child: CircleAvatar(
                                      //     radius: 20,
                                      //     backgroundColor:
                                      //         Theme.of(context).primaryColor,
                                      //     child: Text('${index2 + 1}'),
                                      //   ),
                                      // ),
                                      title: Text(
                                        controllerGetX
                                            .set_list[index]
                                            .setsRow[index2]
                                            .name,
                                      ),

                                      trailing: Text(
                                        '${controllerGetX.set_list[index].setsRow[index2].amount}',
                                      ),
                                    );
                                  },
                                ),
                              ),
                              //============================================
                            ],
                            // children: listItem,
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
