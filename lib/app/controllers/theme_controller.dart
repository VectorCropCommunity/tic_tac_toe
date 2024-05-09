import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final box = GetStorage();
  var theme = "".obs;
  final count = 0.obs;

  @override
  void onInit() {
    theme.value = box.read("theme") ?? "light";
    print(theme);

    if (theme.value == "light") {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }

    super.onInit();
  }

  @override
  void onReady() {
    print(theme);

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Initially set to light

  void toggleTheme() {
    if (theme.value == "light") {
      theme.value = "dark";
      box.write('theme', 'dark');
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      theme.value = "light";
      box.write('theme', 'light');
      Get.changeThemeMode(ThemeMode.light);
    }

    print(theme.value);
  }
}
