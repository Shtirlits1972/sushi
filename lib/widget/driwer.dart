import 'package:flutter/material.dart';
import 'package:sushi_sql/form/ingridient_form.dart';
import 'package:sushi_sql/form/recipe_form.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Text('Menu'),
          ),
          //============================================
          ListTile(
            title: Text('Recipes'),
            onTap: () {
              Navigator.pushNamed(context, RecipeForm.route);
            },
          ),
          //===================================
          const Divider(color: Colors.grey, thickness: 1),
          ListTile(
            title: Text('Ingridients'),
            onTap: () {
              Navigator.pushNamed(context, IngridientForm.route);
            },
          ),

          //  RecipeForm
          const Divider(color: Colors.grey, thickness: 1),
          ListTile(
            title: Text('Cancel'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
