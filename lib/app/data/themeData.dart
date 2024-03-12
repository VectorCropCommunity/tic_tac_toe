import 'package:flutter/material.dart';

// Light Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue, // Adjust for your preference
  hintColor: Colors.green, // Adjust for your preference
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    foregroundColor: Colors.black
  ),
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
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white
  ),
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
