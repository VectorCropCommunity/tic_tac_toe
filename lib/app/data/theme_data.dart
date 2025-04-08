import 'package:flutter/material.dart';

ThemeData pinkTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.pink, // Widget highlights (e.g., O's or main background)
  primaryColorLight: Colors.pink[300],
  primaryColorDark: Colors.pink[700],
  scaffoldBackgroundColor: Colors.pink[50],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.pink[600],
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
  ),
);

// Green Theme
ThemeData greenTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.green,
  primaryColorLight: Colors.green[300],
  primaryColorDark: Colors.green[800],
  scaffoldBackgroundColor: Colors.green[50],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green[600],
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
  ),
);

// Orange Theme
ThemeData orangeTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.orange,
  primaryColorLight: Colors.orange[300],
  primaryColorDark: Colors.orange[800],
  scaffoldBackgroundColor: Colors.orange[50],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.orange[600],
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
  ),
);

// Blue Theme
ThemeData blueTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  primaryColorLight: Colors.blue[300],
  primaryColorDark: Colors.blue[800],
  scaffoldBackgroundColor: Colors.blue[50],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue[600],
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
  ),
);

// (You can still keep your existing lightTheme/darkTheme if you want.)

// Light Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue, // Adjust for your preference
  hintColor: Colors.green, // Adjust for your preference
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(foregroundColor: Colors.black),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
  ),
  highlightColor: Colors.black,
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blueGrey, // Adjust for your preference
  ),
);

// Dark Theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
  highlightColor: Colors.white,
  primaryColor: Colors.teal, // Adjust for your preference
  hintColor: Colors.amber, // Adjust for your preference
  scaffoldBackgroundColor: Colors.black45,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.grey, // Adjust for your preference
  ),
);
