import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/app/controllers/theme_controller.dart';
import 'package:tic_tac_toe/app/routes/app_pages.dart';

class HomeController extends GetxController {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  ThemeController themeController = Get.find<ThemeController>();
  RxBool isInternetAvailable = false.obs;
  Rxn<UserCredential> user = Rxn<UserCredential>();

  @override
  void onInit() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      debugPrint("Connectivity: ${result[0].toString()}");
      if (result.contains(ConnectivityResult.mobile)) {
        isInternetAvailable.value = true;
      } else if (result.contains(ConnectivityResult.wifi)) {
        isInternetAvailable.value = true;
      } else {
        isInternetAvailable.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
  }

  Future<void> playOnline() async {
    user.value = await FirebaseAuth.instance.signInAnonymously();
    Get.dialog(
      AlertDialog(
        // title: const Text(
        //   "Play Online",
        //   textAlign: TextAlign.center,
        // ),
        actionsAlignment: MainAxisAlignment.center,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          MaterialButton(
            height: 50,
            minWidth: Get.width * 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.black, width: 3),
            ),
            color: Colors.yellow[800],
            elevation: 0,
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.ONLINE, arguments: {"user": user.value});
            },
            child: const Text(
              'Play Online',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          )
        ]),
      ),
    );
  }
}
