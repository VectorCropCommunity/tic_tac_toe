import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final box = GetStorage();

  final Rx<Color> selectedSeedColor = Colors.deepPurple.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  final List<Color> availableSeeds = [
    Colors.deepPurple,
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.pink,
  ];

  @override
  void onInit() {
    final int? savedColor = box.read("seedColor");
    final String? savedMode = box.read("themeMode");

    if (savedColor != null) {
      selectedSeedColor.value = availableSeeds[savedColor];
    } else {}

    if (savedMode != null) {
      themeMode.value = ThemeMode.values.firstWhere(
        (m) => m.toString() == savedMode,
        orElse: () => ThemeMode.system,
      );
    }

    super.onInit();
  }

  void switchSeedColor(int index) {
    selectedSeedColor.value = availableSeeds[index];
    box.write("seedColor", index);
  }

  void switchThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    box.write("themeMode", mode.toString());
  }
}
