import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/game_controller.dart';

class GameView extends GetResponsiveView<GameController> {
  GameView({super.key});

  @override
  Widget? phone() {
    final scheme = Get.theme.colorScheme;

    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: scheme.surface,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  "Loading Game...",
                  style: TextStyle(fontSize: 16, color: scheme.onSurface),
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: controller.resetGame,
              icon: Icon(Icons.refresh, color: scheme.onSurface),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => controller.resetGame(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(Get.context!).size.height,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Player Turn Indicator
                        Obx(
                          () => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  controller.oTurn.value
                                      ? scheme.primaryContainer
                                      : scheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(
                                100,
                              ), // 💊 pill shape
                              boxShadow: [
                                BoxShadow(
                                  color: scheme.shadow.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.oTurn.value ? "⭕" : "❌",
                                  style: const TextStyle(
                                    fontSize: 28,
                                  ), // Emoji avatar
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  controller.headingText.value,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        controller.oTurn.value
                                            ? scheme.onPrimaryContainer
                                            : scheme.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Game Grid
                        if (controller.isVsAI.value)
                          Obx(() {
                            final selected = controller.difficulty.value;
                            final hasStarted = controller.hasGameStarted();
                            final options = ['easy', 'medium', 'hard'];
                            final labels = ['🟢 Easy', '🟠 Medium', '🔴 Hard'];

                            return Wrap(
                              spacing: 12,
                              children: List.generate(options.length, (index) {
                                final value = options[index];
                                final label = labels[index];
                                final isSelected = value == selected;

                                return ChoiceChip(
                                  label: Text(label),
                                  selected: isSelected,
                                  onSelected:
                                      hasStarted
                                          ? null // disable after game started
                                          : (_) =>
                                              controller.difficulty.value =
                                                  value,
                                  selectedColor:
                                      Theme.of(
                                        Get.context!,
                                      ).colorScheme.primaryContainer,
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isSelected
                                            ? Theme.of(
                                              Get.context!,
                                            ).colorScheme.onPrimaryContainer
                                            : Theme.of(
                                              Get.context!,
                                            ).colorScheme.onSurface,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  shape: StadiumBorder(),
                                );
                              }),
                            );
                          }),

                        Expanded(
                          child: GridView.builder(
                            itemCount: 9,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemBuilder: (context, index) {
                              return Obx(() {
                                final isMatched = controller.matchedIndex
                                    .contains(index);
                                final isTapped =
                                    controller.tappedIndex.value == index;

                                final bgColor =
                                    isMatched
                                        ? scheme.tertiaryContainer
                                        : (index % 2 == 0
                                            ? scheme.primaryContainer
                                            : scheme.secondaryContainer);

                                return TweenAnimationBuilder<double>(
                                  tween: Tween(
                                    begin: 1.0,
                                    end: isTapped ? 1.1 : 1.0,
                                  ),
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.easeOutBack,
                                  onEnd: () {
                                    if (isTapped)
                                      controller.tappedIndex.value = -1;
                                  },
                                  builder: (context, scale, child) {
                                    return Transform.scale(
                                      scale: scale,
                                      child: child,
                                    );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: scheme.outlineVariant,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(6),
                                        splashColor: scheme.primary.withOpacity(
                                          0.2,
                                        ),
                                        highlightColor: scheme.primary
                                            .withOpacity(0.1),
                                        onTap: () => controller.onTapped(index),
                                        child: Center(
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            transitionBuilder: (
                                              child,
                                              animation,
                                            ) {
                                              final rotate = Tween(
                                                begin: pi,
                                                end: 0.0,
                                              ).animate(animation);
                                              return AnimatedBuilder(
                                                animation: rotate,
                                                child: child,
                                                builder: (context, child) {
                                                  final isUnder =
                                                      (ValueKey(
                                                            controller
                                                                .list[index],
                                                          ) !=
                                                          child?.key);
                                                  final tilt =
                                                      isUnder
                                                          ? min(
                                                            rotate.value,
                                                            pi / 2,
                                                          )
                                                          : rotate.value;
                                                  return Transform(
                                                    alignment: Alignment.center,
                                                    transform:
                                                        Matrix4.rotationY(tilt),
                                                    child: child,
                                                  );
                                                },
                                              );
                                            },
                                            child: Text(
                                              controller.list[index],
                                              key: ValueKey(
                                                controller.list[index],
                                              ), // important for switching
                                              style: TextStyle(
                                                fontSize: 48,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    controller.list[index] ==
                                                            'X'
                                                        ? scheme
                                                            .onPrimaryContainer
                                                        : controller
                                                                .list[index] ==
                                                            'O'
                                                        ? scheme
                                                            .onSecondaryContainer
                                                        : Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          "vectorcrop.com",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // Confetti
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: controller.confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        numberOfParticles: 40,
                        maxBlastForce: 30,
                        minBlastForce: 10,
                        emissionFrequency: 0.05,
                        gravity: 0.3,
                        particleDrag: 0.05,
                        colors: const [
                          Colors.red,
                          Colors.green,
                          Colors.blue,
                          Colors.orange,
                          Colors.purple,
                          Colors.pink,
                          Colors.yellow,
                        ],
                        strokeWidth: 0,
                        blastDirection: -pi / 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
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
          ),
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
                          color:
                              controller.oTurn.value
                                  ? Get.theme.primaryColorDark
                                  : Get.theme.primaryColorLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            controller.headingText.value,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                              color:
                                  controller.list[index] == 'X'
                                      ? Get.theme.primaryColorLight
                                      : controller.list[index] == 'O'
                                      ? Get.theme.primaryColorDark
                                      : controller.matchedIndex.contains(index)
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Center(
                                  child: Text(
                                    controller.list[index],
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          controller.list[index] == 'X'
                                              ? Get.theme.primaryColorLight
                                              : Get.theme.primaryColorDark,
                                    ),
                                  ),
                                ),
                                if (controller.matchedIndex.contains(index))
                                  AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    color: Colors.white.withOpacity(0.7),
                                  ),
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
          ),
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
                          color:
                              controller.oTurn.value
                                  ? Get.theme.primaryColorDark
                                  : Get.theme.primaryColorLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            controller.headingText.value,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                              color:
                                  controller.list[index] == 'X'
                                      ? Get.theme.primaryColorLight
                                      : controller.list[index] == 'O'
                                      ? Get.theme.primaryColorDark
                                      : controller.matchedIndex.contains(index)
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Center(
                                  child: Text(
                                    controller.list[index],
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          controller.list[index] == 'X'
                                              ? Get.theme.primaryColorLight
                                              : Get.theme.primaryColorDark,
                                    ),
                                  ),
                                ),
                                if (controller.matchedIndex.contains(index))
                                  AnimatedContainer(
                                    duration: const Duration(seconds: 1),
                                    color: Colors.white.withOpacity(0.7),
                                  ),
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
