import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tic_tac_toe/app/routes/app_pages.dart';
import 'package:tic_tac_toe/main.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.fastOutSlowIn,
            margin: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                themeController.toggleTheme();
              },
              splashColor: Colors.transparent,
              splashRadius: 1,
              icon:
                  //  !themeController.isLightTheme.value
                  //     ? const Icon(
                  //         Icons.light_mode,
                  //       )
                  const Icon(
                Icons.dark_mode,
                color: Color.fromARGB(255, 245, 193, 23),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage('./assets/images/Cover.png'),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("./assets/images/Logo.png"),
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.GAME);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                        color: Colors.black, width: 3, strokeAlign: 1)),
                color: Colors.yellow[800],
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Play",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "vectorcrop.com",
              ),
            ),
          )
        ],
      ),
    );
  }
}
