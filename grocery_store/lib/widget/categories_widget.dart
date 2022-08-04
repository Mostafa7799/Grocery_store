import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/inner_screens/cat_screen.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget(
      {Key? key, required this.catText, required this.imgPath, required this.color})
      : super(key: key);
  final String catText, imgPath;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    double _screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black87;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryScreen.routeName, arguments: catText);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.amber.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: _screenWidth * .3,
              width: _screenWidth * .3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgPath),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Text(
              catText,
              style: mainStyle().copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
