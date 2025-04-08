import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tic_tac_toe/app/controllers/theme_controller.dart';
import 'package:tic_tac_toe/app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final themeController = Get.put(ThemeController());

  runApp(
    Obx(
      () => GetMaterialApp(
        title: "Tic Tac Toe",
        debugShowCheckedModeBanner: false,
        themeMode: themeController.themeMode.value,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeController.selectedSeedColor.value,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: themeController.selectedSeedColor.value,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
}
