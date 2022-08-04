import 'package:flutter/cupertino.dart';

import '../const/style.dart';
import '../services/utils.dart';

class EmptyProduct extends StatelessWidget {
  const EmptyProduct({Key? key, required this.text}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    Utils utils = Utils(context: context);
    Size size = utils.getScreenSize;
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/box.png',
            height: size.height*.5,
            width: size.width*.7,
          ),
          Text(
            text,
            style: mainStyle(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
