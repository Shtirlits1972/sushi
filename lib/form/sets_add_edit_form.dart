import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sushi_sql/controller/sets_controller.dart';
import 'package:sushi_sql/crud/sets_crud.dart';
import 'package:sushi_sql/crud/sets_row_crud.dart';
import 'package:sushi_sql/form/sets_row_form.dart';
import 'package:sushi_sql/model/sets.dart';
import 'package:sushi_sql/model/sets_row.dart';
import 'package:sushi_sql/widget/alert.dart';
import 'package:sushi_sql/widget/snack_bar.dart';

class SetsAddEditForm extends StatefulWidget {
  const SetsAddEditForm({Key? key}) : super(key: key);
  static const String route = '/SetsAddEditForm';

  @override
  _SetsAddEditFormState createState() => _SetsAddEditFormState();
}

class _SetsAddEditFormState extends State<SetsAddEditForm> {
  final SetsController setsGetX = Get.put(SetsController());
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = setsGetX.getSetsEdit.value.name;
    print(setsGetX.getSetsEdit);
    var f33 = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Set'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              if (setsGetX.getSetsEdit.value.id == 0) {
                setsGetX.getSetsEdit.value.name = nameController.text;
                Sets sets = await SetsCrud.add(setsGetX.getSetsEdit.value);

                setsGetX.setsEdit(sets);
              }

              await Navigator.pushNamed(
                context,
                SetsRowAddEditForm.route,
                arguments: SetsRow(0, setsGetX.getSetsEdit.value.id, 0, '', 1),
              );
              setState(() {});
            },
            icon: Icon(Icons.add_circle_rounded),
          ),
        ],
      ),

      body: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enyer set name', // Подсказка
                      border: OutlineInputBorder(), // Граница
                    ),
                  ),
                ),
              ),
            ),

            Flexible(
              flex: 8,
              child: ListView.separated(
                separatorBuilder:
                    (context, index) => const Divider(thickness: 1),
                itemCount: setsGetX.getSetsEdit.value.setsRow.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    onDismissed: (direction) async {
                      try {
                        await SetsRowCrud.del(
                          setsGetX.getSetsEdit.value.setsRow[index].id,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          snackBarOK(
                            '${setsGetX.getSetsEdit.value.setsRow[index].name} is deleted!',
                          ),
                        );

                        setsGetX.getSetsEdit.value.setsRow.removeWhere(
                          (item) =>
                              item.id ==
                              setsGetX.getSetsEdit.value.setsRow[index].id,
                        );
                        setState(() {});
                      } catch (e) {
                        print(e);
                      }
                    },
                    key: Key(
                      setsGetX.getSetsEdit.value.setsRow[index].id.toString(),
                    ),
                    child: InkWell(
                      onLongPress: () {
                        Navigator.pushNamed(
                          context,
                          SetsRowAddEditForm.route,
                          arguments: setsGetX.setsEdit.value.setsRow[index],
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
                          '${setsGetX.getSetsEdit.value.setsRow[index].name}',
                          style: const TextStyle(fontSize: 20),
                        ),

                        trailing: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${setsGetX.getSetsEdit.value.setsRow[index].amount}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
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
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () async {
                            //==//==//==//=================================================
                            if (nameController.text.trim().isEmpty) {
                              showAlertDialog(context, 'enter set name');
                            } else {
                              setsGetX.getSetsEdit.value.name =
                                  nameController.text;

                              if (setsGetX.getSetsEdit.value.id == 0) {
                                await SetsCrud.add(
                                  setsGetX.getSetsEdit.value,
                                ).then((value) {
                                  setsGetX.addOrUpdateSets(value);
                                });
                              } else {
                                await SetsCrud.edit(setsGetX.getSetsEdit.value);
                                setsGetX.addOrUpdateSets(
                                  setsGetX.getSetsEdit.value,
                                );
                              }
                              setsGetX.setSetsEdit(Sets.empty());
                              Navigator.pop(context);
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
                            setsGetX.setSetsEdit(Sets.empty());
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
