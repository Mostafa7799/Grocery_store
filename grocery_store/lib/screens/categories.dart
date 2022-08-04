import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/services/utils.dart';
import 'package:grocery_store/widget/categories_widget.dart';
import 'package:grocery_store/const/style.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> catInfo = [
      {'imgPath': 'assets/images/cat/fruits.png', 'catText': 'Fruits'},
      {'imgPath': 'assets/images/cat/veg.png', 'catText': 'Vegetables'},
      {'imgPath': 'assets/images/cat/spices.png', 'catText': 'Herbs'},
      {'imgPath': 'assets/images/cat/nuts.png', 'catText': 'Nuts'},
      {'imgPath': 'assets/images/cat/grains.png', 'catText': 'Grains'},
      {'imgPath': 'assets/images/cat/spices.png', 'catText': 'Spices'},
    ];

    final utils = Utils(context: context);
    Color color = utils.color;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: mainStyle().copyWith(color: color),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240 / 250,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: List.generate(
            6,
            (index) {
              return CategoriesWidget(
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
                color: Colors.blue,
              );
            },
          ),
        ),
      ),
    );
    ;
  }
}
