import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

import '../controllers/game_controller.dart';

class GameView extends GetResponsiveView<GameController> {
  GameView({Key? key}) : super(key: key);

  @override
  Widget? phone() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.all(10),
                child: IconButton(
                  onPressed: () {
                    controller.resetGame();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              )
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Player Selection
                    Expanded(
                      flex: 1,
                      child: Obx(
                        () => GestureDetector(
                          onTap: () {
                            // controller.showReset();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.bounceIn,
                            width: double.infinity,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: controller.oTurn.value
                                    ? Get.theme.primaryColorDark
                                    : Get.theme.primaryColorLight,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              controller.headingText.value,
                              style: const TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),
                    ),
                    //Check Box

                    Expanded(
                      flex: 3,
                      child: AnimatedGrid(
                        initialItemCount: 9,
                        itemBuilder: (BuildContext context, index, value) {
                          return Obx(
                            () => GestureDetector(
                              onTap: () {
                                controller.onTapped(index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.bounceIn,
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: controller.list[index] == 'X'
                                        ? Get.theme.primaryColorLight
                                        : controller.list[index] == 'O'
                                            ? Get.theme.primaryColorDark
                                            : controller.matchedIndex
                                                    .contains(index)
                                                ? Colors.white.withOpacity(0.8)
                                                : Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Center(
                                      child: Text(
                                        controller.list[index],
                                        style: TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold,
                                            color: controller.list[index] == 'X'
                                                ? Get.theme.primaryColorLight
                                                : Get.theme.primaryColorDark),
                                      ),
                                    ),
                                    if (controller.matchedIndex.contains(index))
                                      AnimatedContainer(
                                        duration: const Duration(seconds: 1),
                                        color: Colors.white.withOpacity(0.7),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                      ),
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
              ),
            ],
          ),
        ),
        Positioned(
          top: 100,
          child: ConfettiWidget(
            confettiController: controller.confettiController,
            blastDirection: pi / 2.4,
            emissionFrequency: 0.08,
            gravity: 00.2,
            particleDrag: 0.1,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        ),
      ],
    );
  }

  @override
  Widget? tablet() {
    // TODO: implement tablet
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                controller.resetGame();
              },
              icon: const Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
// Player Selection
                Expanded(
                  child: Obx(
                    () => GestureDetector(
                      onTap: () {
                        // controller.showReset();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.bounceIn,
                        width: double.infinity,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: controller.oTurn.value
                                ? Get.theme.primaryColorDark
                                : Get.theme.primaryColorLight,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          controller.headingText.value,
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                ),
//Check Box

                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (BuildContext context, int index) {
                      return Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller.onTapped(index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.bounceIn,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: controller.list[index] == 'X'
                                    ? Get.theme.primaryColorLight
                                    : controller.list[index] == 'O'
                                        ? Get.theme.primaryColorDark
                                        : controller.matchedIndex
                                                .contains(index)
                                            ? Colors.white.withOpacity(0.8)
                                            : Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Center(
                                  child: Text(
                                    controller.list[index],
                                    style: TextStyle(
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold,
                                        color: controller.list[index] == 'X'
                                            ? Get.theme.primaryColorLight
                                            : Get.theme.primaryColorDark),
                                  ),
                                ),
                                if (controller.matchedIndex.contains(index))
                                  AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    color: Colors.white.withOpacity(0.7),
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget? desktop() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                controller.resetGame();
              },
              icon: const Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
// Player Selection
                Expanded(
                  child: Obx(
                    () => GestureDetector(
                      onTap: () {
                        // controller.showReset();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.bounceIn,
                        width: double.infinity,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: controller.oTurn.value
                                ? Get.theme.primaryColorDark
                                : Get.theme.primaryColorLight,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          controller.headingText.value,
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                ),
//Check Box

                Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 9,
                    itemBuilder: (BuildContext context, int index) {
                      return Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller.onTapped(index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.bounceIn,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: controller.list[index] == 'X'
                                    ? Get.theme.primaryColorLight
                                    : controller.list[index] == 'O'
                                        ? Get.theme.primaryColorDark
                                        : controller.matchedIndex
                                                .contains(index)
                                            ? Colors.white.withOpacity(0.8)
                                            : Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Center(
                                  child: Text(
                                    controller.list[index],
                                    style: TextStyle(
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold,
                                        color: controller.list[index] == 'X'
                                            ? Get.theme.primaryColorLight
                                            : Get.theme.primaryColorDark),
                                  ),
                                ),
                                if (controller.matchedIndex.contains(index))
                                  AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    color: Colors.white.withOpacity(0.7),
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
