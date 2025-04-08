import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tic_tac_toe/app/controllers/theme_controller.dart';
import 'package:tic_tac_toe/app/data/theme_data.dart';

import 'app/routes/app_pages.dart';

final themeController = Get.put(ThemeController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize the ThemeController once, preferably via initialBinding
  runApp(
    GetMaterialApp(
      title: "Tic Tac Toe",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder.put(() => ThemeController()),
      theme: lightTheme, // you could import this from your themeData.dart
      darkTheme: darkTheme, // same here
      themeMode: ThemeMode.system,
    ),
  );
}
