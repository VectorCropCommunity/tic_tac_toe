import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final RxBool isLightTheme = RxBool(true);
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Initially set to light

  void toggleTheme() {
    Get.changeThemeMode(isLightTheme.value ? ThemeMode.light : ThemeMode.dark);
    isLightTheme.value = !isLightTheme.value;
  }
}
