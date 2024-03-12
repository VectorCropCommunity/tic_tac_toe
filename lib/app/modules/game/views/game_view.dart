import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tic_tac_toe/main.dart';

import '../controllers/game_controller.dart';

class GameView extends GetView<GameController> {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(() => Container(
                margin: EdgeInsets.all(10),
                child: controller.oRrefresh.value
                    ? IconButton(
                        onPressed: () {
                          controller.resetGame();
                        },
                        icon: Icon(Icons.refresh))
                    : Container(),
              ))
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
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: controller.oTurn.value
                                ? Theme.of(context).hintColor
                                : !controller.oTurn.value
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[900],
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: !controller.oRrefresh.value
                              ? Text(
                                  controller.oTurn.value
                                      ? "O's Turn"
                                      : "X's Turn",
                                  style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  controller.winner.value == "X"
                                      ? "Winner is ${controller.winner.value}"
                                      : controller.winner.value == "O"
                                          ? "Winner is ${controller.winner.value}"
                                          : "Reset Game",
                                  style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
//Check Box

                Expanded(
                  flex: 3,
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (BuildContext context, index) {
                      return Obx(
                        () => GestureDetector(
                          onTap: () {
                            controller.onTapped(index);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: themeController.isLightTheme.value
                                    ? Colors.grey[300]
                                    : Colors.grey[900],
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
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).hintColor),
                                  ),
                                ),
                                controller.matchedIndex.contains(index)
                                    ? Transform.rotate(
                                        origin: Offset.zero,
                                        angle: controller.angle.value,
                                        child: Image.asset(
                                          "./assets/images/line.png",
                                          fit: BoxFit.cover,
                                          color:
                                              Theme.of(context).highlightColor,
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
    );
  }
}
