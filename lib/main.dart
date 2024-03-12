import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tic_tac_toe/app/controllers/theme_controller.dart';
import 'package:tic_tac_toe/app/data/themeData.dart';

import 'app/routes/app_pages.dart';

final themeController = Get.put(ThemeController());

void main() {
  runApp(Obx(
    () => GetMaterialApp(
      title: "Tic Tac Toe",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      theme: themeController.isLightTheme.value ? lightTheme : darkTheme,
      getPages: AppPages.routes,
    ),
  ));
}
