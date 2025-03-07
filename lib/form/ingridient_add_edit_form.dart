import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sushi_sql/controller/ingridient_controller.dart';
import 'package:sushi_sql/crud/ingridient_crud.dart';
import 'package:sushi_sql/model/ingridient.dart';
import 'package:sushi_sql/widget/alert.dart';
import 'package:sushi_sql/widget/driwer.dart';

class IngridientAddEditForm extends StatefulWidget {
  IngridientAddEditForm({Key? key, required this.model}) : super(key: key);
  Ingridient model;
  static const String route = '/IngridientAddEditForm';

  @override
  _IngridientAddEditFormState createState() => _IngridientAddEditFormState();
}

class _IngridientAddEditFormState extends State<IngridientAddEditForm> {
  final IngridientController controllerGetX = Get.put(IngridientController());
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(
      text: widget.model.name,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Ingridients'),
        centerTitle: true,
      ),

      // drawer: const DrawerMenu(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 8,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enyer ingridient name', // Подсказка
                    border: OutlineInputBorder(), // Граница
                  ),
                ),
              ),
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
                              IngridientCrud.add(widget.model).then((value) {
                                controllerGetX.addIngridient(value);
                                Navigator.pop(context);
                              });
                            } else {
                              IngridientCrud.edit(widget.model).then((value) {
                                controllerGetX.updateIngridient(value);
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
