import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store/const/style.dart';
import 'package:grocery_store/inner_screens/feeds_screen.dart';

import '../services/utils.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
      {Key? key, required this.imgPath, required this.title, required this.subTitle, required this.textButton})
      : super(key: key);
  final String imgPath, title, subTitle, textButton;

  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    final themeState = Utils(context: context).getTheme;
    final Color color = Utils(context: context).color;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Image.asset(
                imgPath,
                width: double.infinity,
                height: size.height * .4,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Whoops!",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey, fontSize: 24),
              ),
              Text(
                subTitle,
                style: TextStyle(color: Colors.grey, fontSize: 24),
              ),
              SizedBox(
                height: size.height * .09,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  primary: Theme.of(context).colorScheme.secondary,
                  onPrimary: color,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle:
                      TextStyle(color: Colors.grey.shade300, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, FeedsScreen.routeName);
                },
                child: Text(
                  textButton,
                  style: mainStyle().copyWith(
                    color: themeState
                        ? Colors.grey.shade300
                        : Colors.grey.shade600,
                    fontSize: 21,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
