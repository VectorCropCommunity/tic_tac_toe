import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tic_tac_toe/app/data/theme_data.dart';

// Make sure you import your newly defined themes: pinkTheme, greenTheme, etc.

class ThemeController extends GetxController {
  final box = GetStorage();

  // This will hold the name of the currently selected theme
  var selectedThemeName = "".obs;

  // Map of theme name to actual ThemeData object
  final Map<String, ThemeData> themes = {
    'Pink': pinkTheme,
    'Green': greenTheme,
    'Orange': orangeTheme,
    'Blue': blueTheme,
    'Light': lightTheme, // If you still have them
    'Dark': darkTheme, // ...
  };

  @override
  void onInit() {
    super.onInit();
    selectedThemeName.value = box.read("theme") ?? "Pink";
    Get.changeTheme(themes[selectedThemeName.value]!);
  }

  // Switch the theme by name
  void switchTheme(String themeName) {
    selectedThemeName.value = themeName;
    box.write('theme', themeName);
    Get.changeTheme(themes[themeName]!);
  }
}
