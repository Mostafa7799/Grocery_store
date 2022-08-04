import 'package:flutter/material.dart';

class Style {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        scaffoldBackgroundColor:
            isDarkTheme ? Color(0xFF00001a) : Color(0xFFFFFFFF),
        primaryColor: Colors.blue,
        colorScheme: ThemeData().colorScheme.copyWith(
            secondary: isDarkTheme ? Color(0xFF1a1f3c) : Color(0xFFE8fDfD),
            brightness: isDarkTheme ? Brightness.dark : Brightness.light),
        cardColor: isDarkTheme ? Color(0xff121717) : Color(0xFFF2fDfD),
        canvasColor: isDarkTheme ? Colors.black87 : Colors.grey[50],
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme:
                isDarkTheme ? ColorScheme.dark() : ColorScheme.light()));
  }
}
