import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key, required this.isLoading, required this.child})
      : super(key: key);
  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                color: Colors.black.withOpacity(.7),
              )
            : Container(),
        isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Container(),
      ],
    );
  }
}
