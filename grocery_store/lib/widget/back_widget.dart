import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../services/utils.dart';

class BackWidget extends StatelessWidget {
  const BackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context: context).getScreenSize;
    final Color color = Utils(context: context).color;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: color,
        size: 26,
      ),
    );
  }
}
