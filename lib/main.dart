import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tic_tac_toe/app/controllers/theme_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'app/routes/app_pages.dart';

final themeController = Get.put(ThemeController());
FirebaseDatabase database = FirebaseDatabase.instance;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  GetStorage().initStorage();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    print(value.name);
  });

  runApp(
    GetMaterialApp(
      title: "Tic Tac Toe",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder.put(() => ThemeController()),
      // theme: themeController.isLightTheme.value
      //     ? ThemeData.light()
      //     : ThemeData.dark(),
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColorLight: Colors.blue,
          cardColor: Colors.black,
          primaryColorDark: Colors.green[600]),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColorLight: Colors.orange[800],
          cardColor: Colors.white,
          primaryColorDark: Colors.yellow[800]),
      themeMode: ThemeMode.system,
    ),
  );
}
