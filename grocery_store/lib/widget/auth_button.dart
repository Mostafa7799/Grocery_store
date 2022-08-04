import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.textButton,
    required this.function,
    this.primary = Colors.white38,
  }) : super(key: key);

  final String textButton;
  final Function function;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: primary,
      ),
      onPressed: () {
        function();
      },
      child: Text(
        textButton,
        style: TextStyle(color: Colors.white, fontSize: 19),
      ),
    );
  }
}
